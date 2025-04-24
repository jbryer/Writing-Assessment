
## DAACS Writing Assessment

#### Abstract

Significant advancements in large language models have occurred over the
past decade. This study explores how some of the more recent tokenizers
compare to traditional n-gram-style tokenization procedures in the
context of scoring a diagnostic assessment. Results show improvements,
but predictive models might matter more.

**Keywords:** natural language processing, machine learning, automated
essay scoring

#### Contents

- [NCME 2025 Paper](manuscript/NCME_daacs_writing_nlp.pdf)
- [NCME 2025 Slides](slides/DAACS-Writing.pdf)
- [Poster](poster/Writing-NLP-Poster.pdf)
- [Github repository](https://github.com/DAACS/DAACS-NLP) containing the
  Python code to run all the models.

There is a [Shiny Application](shiny/app.R) that allows interaction with
the results. This can be run using the following command:

``` r
shiny::runGitHub(repo = 'Writing-Assessment', username = 'jbryer', subdir = 'shiny')
```

*DAACS was developed under grants P116F150077 and R305A210269 from the
U.S. Department of Education. However, the contents do not necessarily
represent the policy of the U.S. Department of Education, and you should
not assume endorsement by the Federal Government.*
