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

It displays on each line a tuple of input size, batch size, and the minimum
parallel values at those sizes. For example, the following is the first 100
tuples. The first line reads: with an input size of 2 values, we would get
optimal performance splitting the values into a batch of 2, and we would need
to go through a total of 2 values-worth of wall-clock time. The tenth line,
likewise, reads: with an input size of 11 values, we would get optimal
performance splitting the set into batches of 4 values, spending 7 value-worth
of wall-clock time.

```
(2,2,2)
(3,3,3)
(4,2,4)
(5,3,5)
(6,3,5)
(7,2,6)
(8,2,6)
(9,3,6)
(10,4,7)
(11,4,7)
(12,4,7)
(13,2,8)
(14,2,8)
(15,2,8)
(16,2,8)
(17,3,8)
(18,3,8)
(19,3,9)
(20,3,9)
(21,3,9)
(22,3,9)
(23,3,9)
(24,3,9)
(25,3,9)
(26,3,9)
(27,3,9)
(28,2,10)
(29,2,10)
(30,2,10)
(31,2,10)
(32,2,10)
(33,3,11)
(34,3,11)
(35,3,11)
(36,3,11)
(37,3,11)
(38,3,11)
(39,3,11)
(40,3,11)
(41,3,11)
(42,3,11)
(43,3,11)
(44,3,11)
(45,3,11)
(46,3,11)
(47,3,11)
(48,3,11)
(49,3,11)
(50,3,11)
(51,3,11)
(52,3,11)
(53,3,11)
(54,3,11)
(55,2,12)
(56,2,12)
(57,2,12)
(58,2,12)
(59,2,12)
(60,2,12)
(61,2,12)
(62,2,12)
(63,2,12)
(64,2,12)
(65,3,12)
(66,3,12)
(67,3,12)
(68,3,12)
(69,3,12)
(70,3,12)
(71,3,12)
(72,3,12)
(73,3,12)
(74,3,12)
(75,3,12)
(76,3,12)
(77,3,12)
(78,3,12)
(79,3,12)
(80,3,12)
(81,3,12)
(82,2,14)
(83,2,14)
(84,2,14)
(85,2,14)
(86,2,14)
(87,2,14)
(88,2,14)
(89,2,14)
(90,2,14)
(91,2,14)
(92,2,14)
(93,2,14)
(94,2,14)
(95,2,14)
(96,2,14)
(97,2,14)
(98,2,14)
(99,2,14)
(100,2,14)
(101,2,14)
```

## Conclusion

After playing around with various combinations of the three parameters, a batch
size of 3 seems to somehow be the magic number in minimizing the total number
of values to go through in a parallel environment without bandwidth costs.
