# Main scripts:
## Neural network structures
* `deeper_simple`: Structure with no hidden layer, denoted as S
* `deeper_regions`: Neural with a Regions layer
* `deeper_neigh`: Neural network structure with a Neighborhood layer
* `deeper_neigh_regions`: Neural network structure with a Neighborhood layer and a Regions layer

## Auxiliary scripts (used by the the scripts above)
* `haxby_dataset`: script for loading the dataset and the related weights for initialization
* `common_model_initialization`: Script to initialize the model for each case
* `training_and_importance_extraction`: Script to train the model and to get the importance maps for the model