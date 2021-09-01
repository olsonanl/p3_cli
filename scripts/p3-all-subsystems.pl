=head1 Return All Subsystems in BV-BRC

    p3-all-subsystems [options]

This script returns the IDs of all the subsystems in the BV-BRC database. It supports standard filtering
parameters and the specification of additional columns if desired.

=head2 Parameters

There are no positional parameters.

The command-line options are those given in L<P3Utils/data_options> plus the following.

=over 4

=item fields

List the names of the available fields.

=back

=cut

use strict;
use P3DataAPI;
use P3Utils;

# Get the command-line options.
my $opt = P3Utils::script_opts('', P3Utils::data_options(),
        ['fields|f', 'show available fields']);
# Get access to BV-BRC.
my $p3 = P3DataAPI->new();
if ($opt->fields) {
    my $fieldList = P3Utils::list_object_fields($p3, 'subsystem');
    print join("\n", @$fieldList, "");
} else {
    # Compute the output columns. Note we configure this as an ID-centric method.
    my ($selectList, $newHeaders) = P3Utils::select_clause($p3, subsystem => $opt, 1);
    # Compute the filter.
    my $filterList = P3Utils::form_filter($opt);
    if (! @$filterList) {
        # We must always have a filter, so add a dummy here.
        push @$filterList, ['ne', 'subsystem_id', 'x'];
    }
    # Write the headers.
    P3Utils::print_cols($newHeaders);
    # Process the query.
    my $results = P3Utils::get_data($p3, subsystem => $filterList, $selectList);
    # Print the results.
    for my $result (@$results) {
        P3Utils::print_cols($result, opt => $opt);
    }
}
