package MeteoScrap::Plugins::Base;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(new); 

our @EXPORT = qw();

our $VERSION = '0.01';

sub new {
	my $that = shift;
	my $class = ref($that) || $that; 
	my $self = bless({}, $class);
	$self->{scrap} = shift;
	$self->{data} = shift;
	return $self;
}
sub data {
	my $self = shift;
	return $self->{data};
}
sub scrap {
	my $self = shift;
	return $self->{scrap};
}
1;

__END__

=head1 NAME

MeteoScrap - Base class for MeteoScrap plugins.

=head1 SYNOPSIS

=head1 DESCRIPTION


=head2 EXPORT

None by default.

new on request:
  use MeteoScrap::Plugins::Base qw(new)

=head1 SEE ALSO

=head1 AUTHOR

sho, E<lt>sho@nosferat.usE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by sho

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
