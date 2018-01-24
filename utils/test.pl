#!/usr/bin/env perl
use strict;

use Test::More tests => 83;
use Test::WWW::Mechanize;
use Test::DNS;
use Net::DNS;
use URI;
use YAML qw(LoadFile);
use File::Basename;
use File::Spec;

my $path = dirname($0);

my $sites = LoadFile( File::Spec->catfile( $path, 'test.yaml' ) );

my $dns = Test::DNS->new( nameservers => [ '8.8.8.8', '8.8.4.4' ] );

my @sites = sort keys %$sites;

if (@ARGV) { @sites = @ARGV; }

foreach my $site (@sites) {
    my $config = $sites->{$site};

    # Test main site
    if ( not $config->{stage_only} ) {
        test_site( $site, $config );
    }

    my $stage;

    if ( $config->{stage_only} ) {
        $stage = $site;
    }
    elsif ( $config->{stage} ) {
        $stage = $config->{stage};
    }
    elsif ( not $config->{prod_only} ) {
        ( $stage = $site ) =~ s/\.mozilla\.(.*)$/.allizom.$1/;
    }

    # Test stage site
    if ($stage) {
        test_site( $stage, $config, 1 );
    }
}

done_testing();

sub test_site {
    my ( $site, $config, $stage ) = @_;

    my $haul = 'www.haul.prod.core.us-west-2.appsvcs-generic.nubis.allizom.org';
    if ($stage) {
        $haul =
          'www.haul.stage.core.us-west-2.appsvcs-generic.nubis.allizom.org';
    }
    my $path = $config->{path} // '/';

    my $uri = URI->new($site);
    $uri->path($path);

    my $host = $uri->host;

    if ( $config->{dns} ne 'alias' ) {
        $dns->is_cname( $host => $haul );
    }
    else {
        my @rr = rr($host);
        @rr = map { $_->address } @rr;
        $dns->is_a( $host => \@rr );
    }

    my $mech = Test::WWW::Mechanize->new;
    my $ok   = $mech->get_ok($uri);

    if ( $config->{links} ) {
        $mech->page_links_ok("$site: Check Links");
    }

    if ( $config->{lint} ) {
        $mech->html_lint_ok("$site: Check HTML");
    }
}

