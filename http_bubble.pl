#!/usr/bin/perl
use strict;
use Mongrel2;
use JSON;
use Harbinger;
use Enveloper;
use IO::Socket;
use Net::OpenSoundControl::Client;
use Data::Dumper;
my %allowed = qw( pop pop crinkle crinkle scratch scratch );

my $client = Net::OpenSoundControl::Client->new(Host => "127.0.0.1", Port => 57120);

my $sender_id = "000e2e52-7ad3-4d40-afcc-80d097acc3a6";

my $sub_addr = "tcp://127.0.0.1:9957";
my $pub_addr = "tcp://127.0.0.1:9956";

my $mongrel = Mongrel2::mongrel_init( $sender_id, $sub_addr, $pub_addr );

# {program:"program name", id:"", dest:"", msg:""}
my $cnt=0;
while(1) {
    print "WAITING FOR REQUEST$/";
    my $req = $mongrel->recv( );
    if ($mongrel->is_disconnect( $req )) {
        print "DISCONNECT";
        next;
    } else {
        print $cnt++.$/;#.$response.$/;
        if ($req->{body}) {
            eval {
                my @elms = ();
                my $code = from_json( $req->{body} );
                if ($code->{queue}) {
                    foreach my $elm (@{$code->{queue}}) {
                        if ($allowed{$elm->{type}}) {
                            my $command = $allowed{$elm->{type}};
                            my $x = $elm->{x}||0;
                            my $y = $elm->{y}||0;
                            my $since = $elm->{since}||0;
                            push @elms,['/'.$command, 'f', $x, 'f', $y, 'f', $since];
                        } else {
                            warn "Not allowed: ".$allowed{$code->{type}};
                        }
                    }
                }
                print Dumper(\@elms);
                $client->send(['#bundle', 0,@elms]) if @elms;
            };
            if ($@) {
                $mongrel->reply_http( $req, "COULD NOT SEND $cnt : $@");
            } else {
                # now get state and return it
                # step 1. naively keep returning the state back to the user
                #my $state = Enveloper::get_state();
                my $state = {"ok"=>"ok"};
                my $str = encode_json($state);
                $mongrel->reply_http( $req, $str);#, 200, "OK", {application/jsonapplication);
            }
        } else {
            $mongrel->reply_http( $req, "NO BODY [bubble] $cnt");
        }
    }
}


# Gee instead of a prefix maybe you should make a module?

