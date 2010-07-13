package Module::Install::RPM;

use strict; use warnings;
use base 'Module::Install::Base';
use 5.008;

our $VERSION = '0.01';

sub requires_rpm {
    my ($self, $rpm, $version) = @_;
    
    unless ($self->can_run('rpm')) {
        warn "Unable to locate ``rpm'' executable\n";
        return;
    }

    chomp(my $query = qx(rpm -q $rpm));
    my @parts = split /-/, $query;
    pop @parts;                 # remove and ignore patch level
    my $rpm_version = pop @parts;
    my ($rpm_name) = $query =~ m/(.*?)-\d/;

    if ($version && _version_cmp($rpm_version, $version) == -1) {
        warn " -- $rpm at least version $version required, but found $rpm_version instead\n";
        return;
    }
}


sub _version_cmp {
    my ($v1, $v2) = @_;

    my @v1 = split /\./, $v1;
    my @v2 = split /\./, $v2;

    my $end = @v1 < @v2 ? $#v1 : $#v2;
    for my $i (0..$end) {
        my $c = $v1[$i] <=> $v2[$i];
        return $c if $c;
    }
    return 0;
}

1;

__END__

=head1 NAME

Module::Install::RPM - provide that certain RPMs be installed

=head1 SYNOPSIS

  use inc::Module::Install;

  name      'Your-Module';
  all_from  'lib/Your/Module.pm';

  requires_rpm  'gd';
  requires_rpm  'httpd' => '2.2';

  WriteAll;

=head1 AUTHOR

Jonathan Scott Duff <duff@pobox.com>

=head1 COPYRIGHT

Copyright Jonathan Scott Duff 2010

This software is licensed under the same terms as Perl.
