package MeteoScrap::REST::API;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

use MeteoScrap::REST::API::service;
# Implement the GET HTTP method.
#sub GET {
#	my ( $self, $request, $response ) = @_ ;
#	$response->data()->{ 'uri' } = $request->uri();
#	$response->data()->{ 'api_mess' } = 'Hello, this is MyApp REST API' ;
#	return Apache2::Const::HTTP_OK ;
#}

sub buildNext {
	my ($self, $frag, $req) = @_;
	return MeteoScrap::REST::API::service->new($self, $frag);
}
# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	#return $method eq 'GET';
}
   
1;

