package MeteoScrap::REST::API::services;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

use MeteoScrap;
use MeteoScrap::REST::API::services::service;

our @SERVICES = qw(MeteoFrance);

#Implement the GET HTTP method.
sub GET {
	my ( $self, $request, $response ) = @_;
	return Apache2::Const::HTTP_OK ;
}

sub buildNext {
	my ($self, $frag, $req) = @_;
	$frag !~ /^[\w]+$/ and return; 
	my $ok = undef;
	for(@SERVICES) {
		if($frag eq $_) {
			$ok = 1;
			last;
		} 
	}
	unless($ok) {return undef;}
	my $subh = MeteoScrap::REST::API::services::service->new($self);
	$subh->{name} = $frag;
	return $subh;
}

# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	return $method eq 'GET';
}
   
1;

