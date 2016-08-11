#!/usr/bin/perl -w
# vim: set sw=4 ts=4 tw=78 et si:
#
use 5.010;
use strict;
use warnings;

use Getopt::Long;

my %opt = (
    tables => 'filter',
);
my @optdefs = qw(
    tables=s
    edgelabel
);

GetOptions(\%opt, @optdefs);

my @tables;
my %chains;
my %jumps;
my $last_table = '';

while (<>) {
    read_iptables_line($_);
}

print dot_graph(split ',', $opt{tables});

#--- only functions

# read_iptables_line($line)
#
# Reads the next line from iptables output and creates an entry in the rules
# and or jump table for it.
#
# Returns nothing.
#
sub read_iptables_line {
    my ($line) = @_;
    return if ($line =~ /^#.*$/);
    return if ($line =~ /^COMMIT$/);
    chomp;
    if ($line =~ /^\*(\S+)$/) {
        $last_table = $1;
        push @tables, $1;
        $chains{$1} = {};
        $jumps{$1}  = [];
    }
    elsif ($line =~ /^:(\S+)\s.+$/) {
        $chains{$last_table}->{$1} = { rules => [] };
    }
    elsif ($line =~ /^-A\s(\S+)\s(.+)$/) {
        my $chain = $1;
        my $rule  = $2;
        if ($rule =~ /^(-[io]\s\S*\s)?.*-j\s(\S+)(\s.*)?/) {
            my $iface  = $1 || '';
            my $target = $2;

            # ACCEPT, DROP and REJECT are terminating targets, so we don't want
            # an edge for them.
            unless ($target =~ /^(ACCEPT|DROP|REJECT)$/) {
                my $rn = scalar @{$chains{$last_table}->{$chain}->{rules}};
                push @{$jumps{$last_table}}, [ $chain, $target, $iface, $rn ];
            }
        }
        push @{$chains{$last_table}->{$chain}->{rules}}, $rule;
    }
    else {
        die "unrecognized line: $line";
    }
    return;
} # read_iptables_line()

# dot_graph(@graphs)
#
# Creates a graph in the 'dot' language for all tables given in the list
# @graphs.
#
# Returns the graph as string.
#
sub dot_graph {
    my $subgraphs = '';
    foreach my $graph (@_) {
        $subgraphs .= dot_subgraph($graph);
    }
    my $ranks = join "; ", internal_nodes(@_); # determine all internal chains
    my $graph = <<"EOGRAPH";
digraph iptables {
  { rank = source; $ranks; }
  rankdir = LR;
$subgraphs
}
EOGRAPH
    return $graph;
} # dot_graph()

# dot_subgraph($table)
#
# Creates a subgraph in the 'dot' language for the table given in $table.
#
# Returns the subgraph as string.
#
sub dot_subgraph {
    my ($table) = @_;
    my $nodes  = join "\n    ", dot_nodes($table);
    my $edges  = join "\n    ", dot_edges($table);
    my $graph  = <<"EOGRAPH";
  subgraph $table {
    $nodes
    $edges
  }
EOGRAPH
    return $graph;
} # dot_subgraph()

# dot_edges($table)
#
# Lists all jumps between chains in the given table as edge description in the
# 'dot' language.
#
# Returns a list of edge descriptions.
#
sub dot_edges {
    my ($table) = @_;
    my @edges = ();
    my $re_it = qr/^(MASQUERADE|RETURN|TCPMSS)$/;
    foreach my $edge (@{$jumps{$table}}) {
        my $tp  = ':w';
        my $lbl = '';
        if ($opt{edgelabel} && $edge->[2]) {
            $lbl = " [label=\"$edge->[2]\"]";
        }
        unless ($edge->[1] =~ $re_it) {
            $tp = ":name:w";
        }
        push @edges, "$edge->[0]:R$edge->[3]:e -> $edge->[1]$tp$lbl;";
    }
    return @edges;
} # dot_edges()

# dot_nodes($table)
#
# Lists all chains in the given table as node descriptions in the 'dot'
# language.
#
# Returns a list of node descriptions.
#
sub dot_nodes {
    my ($table) = @_;
    my @nodes = ();
    foreach my $node (keys %{$chains{$table}}) {
        my @rules = ();
        my $rn = 0;
        foreach my $rule (@{$chains{$table}->{$node}->{rules}}) {
            push @rules, qq(<tr><td PORT="R$rn">$rule</td></tr>);
            $rn++;
        }
        my $lbl = "<table border=\"0\" cellborder=\"1\" cellspacing=\"0\">"
                . qq(<tr><td bgcolor="lightgrey" PORT="name">$node</td></tr>\n)
                . join("\n", @rules, "</table>");
        push @nodes, "$node [shape=none,margin=0,label=<$lbl>];";
    }
    return @nodes;
} # dot_nodes()

# internal_nodes(@tables)
#
# Lists all chains from all tables in @tables, that are internal chains.
#
# Returns a list of all internal tables.
#
sub internal_nodes {
    my $re_in     = qr/^(PREROUTING|POSTROUTING|INPUT|FORWARD|OUTPUT)$/;
    my @nodes     = ();
    my %have_node = ();
    foreach my $table (@_) {
        foreach my $node (keys %{$chains{$table}}) {
            if (!$have_node{$node} && $node =~ $re_in) {
                push @nodes, qq("$node");
                $have_node{$node} = 1;
            }
        }
    }
    return @nodes;
} # internal_nodes()
__END__
