package Module::Install::RPM;

use strict; use warnings;
use base 'Module::Install::Base';

our $VERSION = '0.01';

sub requires_rpm {
    my ($self, $rpm, $version) = @_;
    
    unless ($self->can_run('rpm')) {
        warn "Unable to locate ``rpm'' executable\n";
        return;
    }

    my $query = qx(rpm -q $rpm);
    my @parts = split /-/, $query;
    pop @parts;     # remove patch level
    my $rpm_version = pop @parts;
    my ($rpm_name) = $query =~ m/(.*?)-\d/;

    if ($version && index($rpm_version, $version) != 0) {
        warn "$rpm version $version required, but found $rpm_version\n";
        return;
    }
    
    print "$query\n$rpm_version\n$rpm_name\n";

#    system('rpm', $rpm);
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

=head1 LICENSE

This software is licensed under the same terms as Perl.
