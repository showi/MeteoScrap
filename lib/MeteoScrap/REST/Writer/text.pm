package MeteoScrap::REST::Writer::text ;
use strict ;

use JSON::XS ;

use Data::Dumper ;

=head1 NAME


=cut

=head2 new

=cut

sub new{
    my ( $class ) = @_;
    return bless {} , $class;
}

=head2 mimeType

Getter

=cut

sub mimeType{
    return 'text/plain' ;
}

=head2 asBytes

Returns the response as json UTF8 bytes for output.

=cut

sub asBytes{
    my ($self,  $resp ) = @_ ;
    my $str;
	for my $k (keys %$resp) {
		if ($k eq "data") {
			for my $k2 (keys %{$resp->{$k}}) {
				$str .= "$k2=" . $resp->{$k}->{$k2} . "\n";
			}	
		} else {
			
			#$str .= "$k=" . $resp->{$k} . "\n";
		}
	}
	return $str;
    
}

1;
