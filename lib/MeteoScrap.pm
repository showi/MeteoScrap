package MeteoScrap;

use 5.010000;
use strict;
use warnings;

#use lib qw(.);
require Exporter;

use Carp;
use LWP::UserAgent;
use Encode;
use Data::Dump qw(dump);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use MeteoScrap ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
#our %EXPORT_TAGS = ( 'all' => [ qw(
#	
#) ] );

our @EXPORT_OK = qw(); #( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '0.01';

sub new {
	my $that = shift;
	my $class = ref($that) || $that; 
	my $self = bless({}, $class);
	$self->{ua} = LWP::UserAgent->new;
	$self->ua->agent("MeteoScraper/$VERSION");
	return $self;
}

sub ua {
	my $self = shift;
	return $self->{ua};
}

sub load_plugin {
	my $self = shift;
	my $name = shift;
	unless($self->is_plugin_loaded($name)) {
		my $plugin = "MeteoScrap/Plugins/$name.pm";
		print "Using plugin " . $plugin . "\n";
		eval {
			require $plugin;
		};
		if ($@) {
			carp("Cannot load plugin: $plugin\n$@\n");	
			return 0;
		}
		$self->{plugins}->{$name} = 1;
	}
	return 1;
}

sub is_plugin_loaded {
	my $self = shift;
	my $name = shift;
	if ($self->{plugins}->{$name}) {
		return 1;
	}
	return 0;
}

sub parse {
	my $self = shift;
	my ($plugin, $code) = @_;
	$self->stran(\$plugin);
	$self->stran(\$code);
	unless ($self->load_plugin($plugin)) {
		carp("Cannot load plugin: " . $plugin);
		return undef;
	}
	my $pname = "MeteoScrap::Plugins::$plugin";
	my $parser = $pname->new($self, $code);
	my $r_h = $parser->run();
	if ($r_h->{error}) {return undef;}
	#dump($r_h);
	return $r_h;
}

sub http_get {
	my $self = shift;
	my $url = shift;
	my $req = HTTP::Request->new(GET => $url);
	my $res = $self->ua->request($req);
	return $res;
}

sub stran {
	my $s = shift;
	my $r_str = shift;
	$$r_str =~ s/[^\w\d]//g;
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
