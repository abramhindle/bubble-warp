package Enveloper;
use Harbinger;
use IO::File;
use JSON;
use Data::Dumper;
use strict;

use constant PI => 3.14159;

# this piece of crap needs to be OO-ified

$|=1;
my $program = "envelope";
my $instr_cnt = 0;
my $orc = "csound/envelope.csd";
my $sco = "";
my $maxinstr = 6;
my %clients = ();
my $maxvalues = 16;
my $tableperinstr = 3;
my @tables = map { 
    my @a = map { 0.0 * $_ } (1 .. $maxvalues);
    \@a
} ( 1 .. ($tableperinstr * $maxinstr) );


my $lastclient = undef;


#cloned :/
sub register {
	my ($H, $jackit) = @_;
	$H->addHandler($program ,new
	        Harbinger::PipeHandler(
	                'open'=>((!$jackit)?"csound -dm6 -L stdin -o devaudio $orc $sco":
			                    "csound -dm6 -+rtaudio=jack -+jack_client=csoundEnveloper -o devaudio -b 400 -B 2048 -L stdin $orc $sco"),
	                #'open'=>'/bin/cat',
	                autoflush=>1,
	                terminator=>$/,
	                filter=>\&filterit,
	        )
	);
}
# cloned :/
sub cs {
        my ($instr,$time,$dur,@o) = @_;
        my $str = join(" ",("i$instr",(map { sprintf('%0.3f',$_) } ($time,$dur,@o)))).$/;
        return $str;
}
sub filterit {
        my ($self,$name,$id,$dest,$msg) = @_;
        my $msg =  decode_json($msg);
        my $client = $msg->{client} || 0;
        # gee use OO idiot
        $lastclient = $client;
        warn $client;
        my @envs = @{$msg->{data}};
        # hack: client ID chooses the tables they are on
        my $startinstr = $client % $maxinstr;
        my $starttable = 1 + $startinstr * $tableperinstr;
        my $table = $starttable;
        my @msgs = ();
        foreach my $env (@envs) {
            my $i = 0;
            foreach my $elm (@{$env->{values}}) {
                if ($i < $maxvalues) {
                    my $last = $clients{$client}->{$table}->[$i];
                    if ($elm ne "null" && defined($elm) && !floateq($elm, $last)) {
                        $tables[$table - 1]->[$i] = $elm;
                        $clients{$client}->{$table}->[$i] = $elm;
                        push @msgs, cs("6666","0","0.001",$table, $i, $elm);
                    }
                }
                $i++;
            }
            $table++;
        }
        return ($name, $id, $dest, join($/,@msgs));
}

sub sqr { $_[0] * $_[0] };

#cloned again?
sub choose { return @_[rand(@_)]; }
#cloned again?
sub min { ($_[0] > $_[1])?$_[1]:$_[0] }
sub max { ($_[0] < $_[1])?$_[1]:$_[0] }
sub floateq {
    my ($a,$b) = @_;
    return (abs($a - $b) < 0.0001);
}

# for the given client (lastclient)
# return the state
sub get_state {
    #my ($client) = @_;
    my $client = $lastclient;
    #$client = $lastclient unless defined($client);
    my $startinstr = $client % $maxinstr;
    my $starttable = 1 + $startinstr * $tableperinstr;
    my $table = $starttable;
    return [ map { $tables[$table - 1 + $_] } (0..($tableperinstr - 1)) ];
}

1;

        
__DATA__
i6666 0 0.001 1 1 1
i6666 0 0.001 2 1 1
i6666 0 0.001 3 1 1
i6666 0 0.001 1 4 1
i6666 0 0.001 2 4 1
i6666 0 0.001 3 4 1
i6666 0 0.001 1 8 1
i6666 0 0.001 2 8 1
i6666 0 0.001 3 8 1
i6666 0 0.001 1 12 1
i6666 0 0.001 2 12 1
i6666 0 0.001 3 12 1
i6666 0 0.001 1 1 1
i6666 0 0.001 1 2 1
i6666 0 0.001 1 3 1
i6666 0 0.001 1 4 1
i6666 0 0.001 1 5 1
i6666 0 0.001 1 6 1
i6666 0 0.001 1 7 1
i6666 0 0.001 1 8 1
i6666 0 0.001 1 9 1
i6666 0 0.001 1 10 1
i6666 0 0.001 1 11 1
i6666 0 0.001 1 12 1
i6666 0 0.001 1 13 1
i6666 0 0.001 1 14 1
i6666 0 0.001 1 15 1
i6666 0 0.001 1 16 1
i6666 0 0.001 2 1 1
i6666 0 0.001 2 2 1
i6666 0 0.001 2 3 1
i6666 0 0.001 2 4 1
i6666 0 0.001 2 5 1
i6666 0 0.001 2 6 1
i6666 0 0.001 2 7 1
i6666 0 0.001 2 8 1
i6666 0 0.001 2 9 1
i6666 0 0.001 2 10 1
i6666 0 0.001 2 11 1
i6666 0 0.001 2 12 1
i6666 0 0.001 2 13 1
i6666 0 0.001 2 14 1
i6666 0 0.001 2 15 1
i6666 0 0.001 2 16 1
i6666 0 0.001 3 1 1
i6666 0 0.001 3 2 1
i6666 0 0.001 3 3 1
i6666 0 0.001 3 4 1
i6666 0 0.001 3 5 1
i6666 0 0.001 3 6 1
i6666 0 0.001 3 7 1
i6666 0 0.001 3 8 1
i6666 0 0.001 3 9 1
i6666 0 0.001 3 10 1
i6666 0 0.001 3 11 1
i6666 0 0.001 3 12 1
i6666 0 0.001 3 13 1
i6666 0 0.001 3 14 1
i6666 0 0.001 3 15 1
i6666 0 0.001 3 16 1
i6666 0 0.001 4 1 1
i6666 0 0.001 4 2 1
i6666 0 0.001 4 3 1
i6666 0 0.001 4 4 1
i6666 0 0.001 4 5 1
i6666 0 0.001 4 6 1
i6666 0 0.001 4 7 1
i6666 0 0.001 4 8 1
i6666 0 0.001 4 9 1
i6666 0 0.001 4 10 1
i6666 0 0.001 4 11 1
i6666 0 0.001 4 12 1
i6666 0 0.001 4 13 1
i6666 0 0.001 4 14 1
i6666 0 0.001 4 15 1
i6666 0 0.001 4 16 1
i6666 0 0.001 5 1 1
i6666 0 0.001 5 2 1
i6666 0 0.001 5 3 1
i6666 0 0.001 5 4 1
i6666 0 0.001 5 5 1
i6666 0 0.001 5 6 1
i6666 0 0.001 5 7 1
i6666 0 0.001 5 8 1
i6666 0 0.001 5 9 1
i6666 0 0.001 5 10 1
i6666 0 0.001 5 11 1
i6666 0 0.001 5 12 1
i6666 0 0.001 5 13 1
i6666 0 0.001 5 14 1
i6666 0 0.001 5 15 1
i6666 0 0.001 5 16 1
i6666 0 0.001 6 1 1
i6666 0 0.001 6 2 1
i6666 0 0.001 6 3 1
i6666 0 0.001 6 4 1
i6666 0 0.001 6 5 1
i6666 0 0.001 6 6 1
i6666 0 0.001 6 7 1
i6666 0 0.001 6 8 1
i6666 0 0.001 6 9 1
i6666 0 0.001 6 10 1
i6666 0 0.001 6 11 1
i6666 0 0.001 6 12 1
i6666 0 0.001 6 13 1
i6666 0 0.001 6 14 1
i6666 0 0.001 6 15 1
i6666 0 0.001 6 16 1
i6666 0 0.001 7 1 1
i6666 0 0.001 7 2 1
i6666 0 0.001 7 3 1
i6666 0 0.001 7 4 1
i6666 0 0.001 7 5 1
i6666 0 0.001 7 6 1
i6666 0 0.001 7 7 1
i6666 0 0.001 7 8 1
i6666 0 0.001 7 9 1
i6666 0 0.001 7 10 1
i6666 0 0.001 7 11 1
i6666 0 0.001 7 12 1
i6666 0 0.001 7 13 1
i6666 0 0.001 7 14 1
i6666 0 0.001 7 15 1
i6666 0 0.001 7 16 1
i6666 0 0.001 8 1 1
i6666 0 0.001 8 2 1
i6666 0 0.001 8 3 1
i6666 0 0.001 8 4 1
i6666 0 0.001 8 5 1
i6666 0 0.001 8 6 1
i6666 0 0.001 8 7 1
i6666 0 0.001 8 8 1
i6666 0 0.001 8 9 1
i6666 0 0.001 8 10 1
i6666 0 0.001 8 11 1
i6666 0 0.001 8 12 1
i6666 0 0.001 8 13 1
i6666 0 0.001 8 14 1
i6666 0 0.001 8 15 1
i6666 0 0.001 8 16 1
i6666 0 0.001 9 1 1
i6666 0 0.001 9 2 1
i6666 0 0.001 9 3 1
i6666 0 0.001 9 4 1
i6666 0 0.001 9 5 1
i6666 0 0.001 9 6 1
i6666 0 0.001 9 7 1
i6666 0 0.001 9 8 1
i6666 0 0.001 9 9 1
i6666 0 0.001 9 10 1
i6666 0 0.001 9 11 1
i6666 0 0.001 9 12 1
i6666 0 0.001 9 13 1
i6666 0 0.001 9 14 1
i6666 0 0.001 9 15 1
i6666 0 0.001 9 16 1
i6666 0 0.001 10 1 1
i6666 0 0.001 10 2 1
i6666 0 0.001 10 3 1
i6666 0 0.001 10 4 1
i6666 0 0.001 10 5 1
i6666 0 0.001 10 6 1
i6666 0 0.001 10 7 1
i6666 0 0.001 10 8 1
i6666 0 0.001 10 9 1
i6666 0 0.001 10 10 1
i6666 0 0.001 10 11 1
i6666 0 0.001 10 12 1
i6666 0 0.001 10 13 1
i6666 0 0.001 10 14 1
i6666 0 0.001 10 15 1
i6666 0 0.001 10 16 1
i6666 0 0.001 11 1 1
i6666 0 0.001 11 2 1
i6666 0 0.001 11 3 1
i6666 0 0.001 11 4 1
i6666 0 0.001 11 5 1
i6666 0 0.001 11 6 1
i6666 0 0.001 11 7 1
i6666 0 0.001 11 8 1
i6666 0 0.001 11 9 1
i6666 0 0.001 11 10 1
i6666 0 0.001 11 11 1
i6666 0 0.001 11 12 1
i6666 0 0.001 11 13 1
i6666 0 0.001 11 14 1
i6666 0 0.001 11 15 1
i6666 0 0.001 11 16 1
i6666 0 0.001 12 1 1
i6666 0 0.001 12 2 1
i6666 0 0.001 12 3 1
i6666 0 0.001 12 4 1
i6666 0 0.001 12 5 1
i6666 0 0.001 12 6 1
i6666 0 0.001 12 7 1
i6666 0 0.001 12 8 1
i6666 0 0.001 12 9 1
i6666 0 0.001 12 10 1
i6666 0 0.001 12 11 1
i6666 0 0.001 12 12 1
i6666 0 0.001 12 13 1
i6666 0 0.001 12 14 1
i6666 0 0.001 12 15 1
i6666 0 0.001 12 16 1
i6666 0 0.001 13 1 1
i6666 0 0.001 13 2 1
i6666 0 0.001 13 3 1
i6666 0 0.001 13 4 1
i6666 0 0.001 13 5 1
i6666 0 0.001 13 6 1
i6666 0 0.001 13 7 1
i6666 0 0.001 13 8 1
i6666 0 0.001 13 9 1
i6666 0 0.001 13 10 1
i6666 0 0.001 13 11 1
i6666 0 0.001 13 12 1
i6666 0 0.001 13 13 1
i6666 0 0.001 13 14 1
i6666 0 0.001 13 15 1
i6666 0 0.001 13 16 1
i6666 0 0.001 14 1 1
i6666 0 0.001 14 2 1
i6666 0 0.001 14 3 1
i6666 0 0.001 14 4 1
i6666 0 0.001 14 5 1
i6666 0 0.001 14 6 1
i6666 0 0.001 14 7 1
i6666 0 0.001 14 8 1
i6666 0 0.001 14 9 1
i6666 0 0.001 14 10 1
i6666 0 0.001 14 11 1
i6666 0 0.001 14 12 1
i6666 0 0.001 14 13 1
i6666 0 0.001 14 14 1
i6666 0 0.001 14 15 1
i6666 0 0.001 14 16 1
i6666 0 0.001 15 1 1
i6666 0 0.001 15 2 1
i6666 0 0.001 15 3 1
i6666 0 0.001 15 4 1
i6666 0 0.001 15 5 1
i6666 0 0.001 15 6 1
i6666 0 0.001 15 7 1
i6666 0 0.001 15 8 1
i6666 0 0.001 15 9 1
i6666 0 0.001 15 10 1
i6666 0 0.001 15 11 1
i6666 0 0.001 15 12 1
i6666 0 0.001 15 13 1
i6666 0 0.001 15 14 1
i6666 0 0.001 15 15 1
i6666 0 0.001 15 16 1
i6666 0 0.001 16 1 1
i6666 0 0.001 16 2 1
i6666 0 0.001 16 3 1
i6666 0 0.001 16 4 1
i6666 0 0.001 16 5 1
i6666 0 0.001 16 6 1
i6666 0 0.001 16 7 1
i6666 0 0.001 16 8 1
i6666 0 0.001 16 9 1
i6666 0 0.001 16 10 1
i6666 0 0.001 16 11 1
i6666 0 0.001 16 12 1
i6666 0 0.001 16 13 1
i6666 0 0.001 16 14 1
i6666 0 0.001 16 15 1
i6666 0 0.001 16 16 1
