package MeteoScrap::REST::API;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

# Implement the GET HTTP method.
sub GET {
	my ( $self, $request, $response ) = @_ ;
	$response->data()->{ 'message' } = 'Welcome on MeteoScrap REST API' ;
	return Apache2::Const::HTTP_OK ;
}

# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	return $method eq 'GET';
}
   
1;

