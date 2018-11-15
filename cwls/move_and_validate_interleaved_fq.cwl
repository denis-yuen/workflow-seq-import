#!/usr/bin/env cwl-runner

class: Workflow

id: "move-and-validate-a-interleaved-fastq"

label: "A CGP workflow to move and validate an interleave fastq"

cwlVersion: v1.0

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  fastq_in:
    type: File
    doc: "A gzipped interleaved fastq file."

outputs:
  interleaved_fastq_out:
    type: File
    format: edam:format_1930
    outputSource: rename/outfile
  
  report:
    type: File
    format: edam:format_3464
    outputSource: validate/report_json

steps:
  rename:
    in:
      srcfile:
        source: fastq_in
      newname:
        source: fastq_in
        valueFrom: $(self.basename)
    out: [outfile]
    run: rename.cwl

  validate:
    in:
      fastqs_in:
        source: [rename/outfile]
        linkMerge: merge_flattened
    out: [report_json]
    run: cgp-seqval-qc_pairs.cwl

doc: |
  A workflow to copy the input interleaved fastq file to a new place and validate the file format and base quality score range. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

s:codeRepository: https://github.com/cancerit/workflow-seq-import
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:email: mailto:yyaobo@gmail.com
    s:name: Yaobo Xu

dct:creator:
  foaf:name: Yaobo Xu
  foaf:mbox: "yyaobo@gmail.com"
