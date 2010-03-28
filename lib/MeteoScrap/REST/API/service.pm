package MeteoScrap::REST::API::service;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

# Implement the GET HTTP method.
sub GET {
	my ( $self, $request, $response ) = @_ ;
	$response->data()->{ 'frag' } = $self->{frag} ;
	return Apache2::Const::HTTP_OK ;
}

# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	return $method eq 'GET';
}
   
1;

