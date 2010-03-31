package MeteoScrap::Data;

use 5.010000;
use strict;
use warnings;

#use lib qw(.);
require Exporter;

use Carp;
use Data::Dump qw(dump);

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(); 

our @EXPORT = qw();

our $AUTOLOAD;

my %fields = (
	plugin		=> undef,	
	status		=> 0,	
	message		=> undef,
	id 			=> undef,
	country 	=> undef,
	city		=> undef,
	weather 	=> undef,
	sky_condition => undef,
	temp_min 	=> undef,
	temp_max 	=> undef,
	temp 		=> undef,
	dew_point 	=> undef,
	visibility	=> undef,
	relative_humidity => undef,
	pressure 	=> undef,
	url			=> undef,
	postal_code => undef,
	update		=> undef,
);

sub AUTOLOAD {
	my $self = shift;
	my ($method) = $AUTOLOAD =~ /^.*:(.*)$/;
	unless (exists $self->{_permit}->{$method}) {
		confess "Invalid properties '$method'";
	}
	$self->{$method} = shift if @_;
	return $self->{$method};	
}

sub DESTROY {
	my $self = shift;
}
sub new {
	my $that = shift;
	my $class = ref($that) || $that;
	my %prop = (
		%fields,
		_permit => \%fields,
	);
	my $self = bless(\%prop, $class);
	return $self;
}

sub list_properties {
	my $self = shift;
	my @list;
	for my $k (keys %{ $self->{_permit} }) {
		push @list, $k;
	}
	return @list;
}
1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

MeteoScrap - Perl extension for blah blah blah

=head1 SYNOPSIS

  use MeteoScrap;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for MeteoScrap, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

sho, E<lt>sho@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by sho

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
