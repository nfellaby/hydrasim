#!/usr/bin/env nextflow
// nextflow.enable.dsl=2

include { generate_recipes } from './subworkflows/generate_recipes'
include { simulate_datasets } from './subworkflows/simulate_datasets'

process checkPath {    
    script:
    """
    echo "Current PATH: \$PATH" >temp.txt
    """
}


workflow {
    // Check input files
    if (params.reference_csv) {
        reference_csv = file(params.reference_csv, type: "file", checkIfExists:true)
    } else {
        exit 1, "Reference CSV be provided -- aborting"
    }
    if (params.dataset_csv) {
        dataset_csv = file(params.dataset_csv, type: "file", checkIfExists:true)
    } else {
        exit 1, "Dataset CSV be provided -- aborting"
    }

    generate_recipes(reference_csv, dataset_csv)
    simulate_datasets(generate_recipes.out.paired, generate_recipes.out.unpaired)

}