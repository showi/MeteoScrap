package MeteoScrap::Plugins::MeteoFrance;

use 5.010000;
use strict;
use warnings;

require Exporter;

use Carp;
use utf8;
use MeteoScrap::Plugins::Base qw|new|;
use HTML::Tree;
use Data::Dump qw(dump);
use Date::Parse;

our @ISA = qw(Exporter MeteoScrap::Plugins::Base);
our @EXPORT_OK = qw(); 
our @EXPORT = qw();
our $VERSION = '0.01';

our $URL = "http://france.meteofrance.com/france/meteo/?PREVISIONS_PORTLET.path=previsionsville/%CODE%/";
sub run {
	my $self = shift;
	my $url = $URL;
	$self->data->country("France");
	if ($self->data->id() !~ /^\d{6}$/) {
		$self->data->status(0);
		$self->data->message("InvalidId");
		return undef,
	}
	my $code = $self->data->id();
	$url =~ s/%CODE%/$code/;
	$self->data->url($url);
	my $content;
	my $res = $self->scrap->http_get($url);		
	unless ($res->is_success) {
		carp "Request fail for $url\n";
		$self->data->status(0);
		$self->data->message("NetworkError");
		return undef;
	}
	$content = $res->content;
	utf8::decode($content);
	my $data = $self->parse_content(\$content);
	unless ($data) {
		$self->data->status(0);
		$self->data->message("NoData");
		return undef;
	}
	$self->data->status(1);
	for my $k (keys %$data) {
		$self->data->$k($data->{$k});
	}
	return 1;
}

sub parse_content {
	my $self = shift;
	my $tree = HTML::TreeBuilder->new_from_content($_[0]);
	my %data;
	$tree->eof;	
	$self->parse_weather(\%data,
		$tree->look_down('_tag', 'div', 
			sub { $_[0]->attr('class') and $_[0]->attr('class') eq "cityWeather" } 
		)
	);
	$tree->delete;
	return \%data;
}

sub parse_weather {
	my $self = shift;
	my ($r_d, $tree) = @_;
	my $d = $tree->look_down('_tag', 'input',
		sub { $_[0]->attr('id') and $_[0]->attr('id') eq "addFavoritesLieu" }
	);
	if($d->attr('value') != $self->data->id()) {
		$self->data->status(0);
		$self->data->message("InvalidId");
		return undef;
	}
	$d = $tree->look_down('_tag', 'p',
		sub { $_[0]->attr('class') and $_[0]->attr('class') eq "city" }
	);
	($r_d->{city}, $r_d->{postal_code}) = $d->as_text =~ /^\s*([^(]+)\s*\((\d+)\)\s*$/;
	$d = $tree->look_down('_tag', 'p',
		sub { $_[0]->attr('class') and $_[0]->attr('class') eq "refreshed" }
	);
	($r_d->{update}) =  $d->as_text =~ /^[^\d]+(\d+h\d+)\s*$/;
	$r_d->{update} =~ s/h/:/i;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$mon++;
	my $date = "$mday/$mon " .$r_d->{update};
	$r_d->{update} = str2time("$mon/$mday " .$r_d->{update}, 3600); # GMT +1
	$self->parse_today($r_d, $tree->look_down('_tag', 'tr', 
		sub { $_[0]->attr('class') and $_[0]->attr('class') eq "aujourdhui" }
	));
}

sub parse_today {
	my $self = shift;
	my ($r_d, $tree) = @_;
	my $d = $tree->look_down('_tag', 'td',
		sub { $_[0]->attr('class') and $_[0]->attr('class') eq "temperatures" }
	); 
	($r_d->{temp_min}, $r_d->{temp_max}) = $d->as_text =~ /^\s*(-?\d+)\xB0C\s*\/\s*(-?\d+).*$/;
	my $w = $d->look_down('_tag', 'img');
	$r_d->{weather} = $w->attr("alt"); 
	utf8::decode($r_d->{weather});
}
1;

__END__

=head1 NAME

MeteoScrap::Plugins::MeteoFrance - Plugin that parse Meteo France data

=head1 SYNOPSIS

	This plugin is not intended to be use alone, see MeteoScrap for further references.
	The run method is the one called by MeteoScrap...

=head1 SEE ALSO

MeteoScrap module

=head1 AUTHOR

sho, E<lt>sho@nosferat.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by sho

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
