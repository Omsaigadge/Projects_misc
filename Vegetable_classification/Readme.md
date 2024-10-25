# Fruits and Vegetables Image Classification Dataset

This dataset is structured into three main directories: `train`, `test`, and `validation`, each containing images of 36 different fruits and vegetables. The dataset is organized as follows:

## Directory Structure
It is around 2 gb of data. There are subcategories within them with each folder having that particular fruit or vegetable
Fruits_Vegetables/ <br />
├── train/ <br />
├── test/  <br />
├── validation/ <br />

Classes --> [apple, banana, beetroot, bell pepper, cabbage, capsicum, carrot, cauliflower, chilli pepper, 
corn, cucumber, eggplant, garlic, ginger, grapes, jalepeno, kiwi, lemon, lettuce, mango, 
onion, orange, paprika, pear, peas, pineapple, pomegranate, potato, raddish, soy beans, 
spinach, sweetcorn, sweetpotato, tomato, turnip, watermelon]

(Examples of the dataset are present in the repo)
Link to Full dataset: [Dataset](https://drive.google.com/file/d/1CGiAWso43GCsNo_faRq4jdDIlmwy7YI4/view)
## Model training

This project uses a CNN with Keras and TensorFlow. The model consists of convolutional layers, max-pooling layers, and dense layers. The final layer predicts the class of the input image.

Libraries and Dependencies: The project starts by importing essential libraries for data handling (Pandas, Numpy), visualization (Matplotlib), and neural network building (TensorFlow and Keras).

Dataset Paths and Image Preprocessing: Paths to the train, test, and validation datasets are specified, and image dimensions are set. Each image is resized to 180x180 pixels to ensure consistency across the dataset.

Loading the Dataset: The image_dataset_from_directory function loads images from each directory, batches them, shuffles them (for training data), and resizes them based on the specified dimensions. The labels for each class are automatically assigned based on directory names (e.g., apple, banana).

Sample Data Visualization: To understand the dataset, a sample batch of nine images from the training set is displayed with labels, showing both the images and their respective class names.

### Model Architecture: 
The CNN model is defined using a sequential approach. Layers include:

**Rescaling Layer:** Normalizes image pixel values to a [0,1] range <br />
**Convolutional Layers:** Extract features from the images, detecting patterns and details.<br />
**Max Pooling Layers:** Reduce spatial dimensions and focus on the most essential features.<br />
**Flatten Layer:** Converts the 2D features into a 1D vector before feeding into dense layers.<br />
**Dropout Layer:** Helps prevent overfitting by randomly setting a fraction of the input units to zero.<br />
**Dense Layers:** Maps the learned features to output classes, with the final dense layer containing a unit for each class.<br />
**Model Compilation and Training:** The model is compiled with the Adam optimizer, a categorical cross-entropy loss function (used for multi-class classification), and accuracy as the metric. Training runs for ten epochs, using the validation data to evaluate performance.<br />

**Plotting Metrics:** After training, accuracy and loss over each epoch are plotted for both the training and validation datasets. This helps visualize learning progress and spot any overfitting if validation performance drops while training accuracy improves.

**Image Prediction:** A sample image is loaded, preprocessed, and passed through the model to make a prediction. The model returns probabilities for each class, and the class with the highest probability is displayed as the predicted label with confidence.


