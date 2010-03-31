package MeteoScrap::REST::API::services::id;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

use Data::Dump qw(dump);
use MeteoScrap;

# Implement the GET HTTP method.
sub GET {
	my ( $self, $request, $response ) = @_ ;
	my $scrap = new MeteoScrap();
	my $data = $scrap->parse($self->{name}, $self->{id});
	unless ($data->status()) {
		$response->data()->{ "status" } = 0;
		$response->data()->{ "message" } = $data->message();
		return Apache2::Const::HTTP_OK ;
	}
	for my $k ($data->list_properties() ) {
		$response->data()->{ $k } = $data->$k();
	}
	$response->data()->{ "status" } = 1;
	return Apache2::Const::HTTP_OK ;
}

# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	return $method eq 'GET';
}
  
1;

