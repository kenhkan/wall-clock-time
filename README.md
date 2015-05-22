# Wall-Clock Time Optimization

Assuming there is no cost of parallelism (e.g. data transfer and node setup
time), we want to arrive with an optimal batch size, denoted by `s`, given an
input size, `n`.

Given an input size and a batch size, there exists a number of parallel values
required to be compared for completion. For example, if the batch size is the
input size, there is no parallelization, so the number of parallel values is
the input size. On the contrary, if the batch size is two (for a batch size of
one is nonsensical) and the input size is 8, the number of parallel values is
6, since at each step we go through two values for comparison and it would take
3 steps to get to a final value, or 2 x 3.

This program is to give a dataset to visualize what is the optimal batch size
given an input size.

## Usage

Assuming you have [Vagrant](https://www.vagrantup.com/):

```
$ vagrant up
$ vagrant ssh

[In VM]
$ cd /vagrant
$ make
```

If the `vagrant up` process somehow doesn't complete successfully, do:

```
$ vagrant ssh

[In VM]
$ cd /vagrant
$ sudo cabal update
$ sudo cabal install
$ make
```

## Output Format

It displays each input size and its corresponding batch sizes and total
parallel values per line.
