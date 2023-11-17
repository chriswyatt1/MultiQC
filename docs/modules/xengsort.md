---
name: xengsort
url: https://gitlab.com/genomeinformatics/xengsort
description: >
  Fast xenograft read sorter based on space-efficient k-mer hashing
---

The module parses results generated by the `xengsort classify` command.

**Note** - MultiQC parses the standard out from xengsort, hence one has to redirect
command line output to a file in order to use it with the MultiQC module. Also note
that the tool does not register any sample name information in the output, so MultiQC
attempts to fetch the sample name from the file name by default.

For example, if your xengsort command was:

```sh
xengsort classify --index myindex \
  --fastq paired.1.fq.gz --pairs paired.2.fq.gz \
  --prefix myresults \
  --classification count \
  > sample.txt
```