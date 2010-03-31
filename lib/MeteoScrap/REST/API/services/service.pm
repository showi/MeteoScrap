package MeteoScrap::REST::API::services::service;
use base qw/Apache2::REST::Handler/ ;
use warnings ;
use strict ;

use Data::Dump qw(dump);
use MeteoScrap::REST::API::services::id;

# Implement the GET HTTP method.
sub GET {
	my ( $self, $request, $response ) = @_ ;
	$response->data()->{ 'frag' } = $self->{frag};
	return Apache2::Const::HTTP_OK ;
}

# Authorize the GET method.
sub isAuth{
	my ($self, $method, $req) = @ _; 
	return $method eq 'GET';
}
  
sub buildNext {
    my ($self, $frag, $req) = @_; 
    my $subh = MeteoScrap::REST::API::services::id->new($self);
	$frag !~ /^\d+$/ and return undef;
    $subh->{id} = $frag;
    $subh->{name} = $self->{name};
	return $subh;
}
 
1;

