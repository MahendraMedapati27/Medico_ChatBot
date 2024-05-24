# Medico Chat Bot

Medico Chat Bot is a rule-based chatbot designed to facilitate the process of placing and tracking orders for medical supplies. It features the ability to place new orders, track existing orders, add or remove items from the current order, and more.

## Features

- **Place New Order**: Users can easily place a new order for medical supplies.
- **Track Order**: Users can track the status of their existing orders.
- **Add/Remove Items**: Users can add or remove items from their current order before finalizing it.
- **Database Integration**: Utilizes a MySQL database for data storage and retrieval.
- **Web Interface**: Includes a web interface for easy interaction with the chatbot.

  ## ChatBot Working Explaination Video Link
  

https://drive.google.com/file/d/13TbKrHyZogxOGSfMnE2nSvX-FRJCAJ2B/view?usp=sharing



## Files

|-- main.py
|-- generic_helper.py
|-- db_helper.py
|-- pharmacare.sql
|-- home.html
|-- banner.jpg
|-- menu.jpg


## Tech Stack

- **Dialogflow**: Used for natural language understanding and processing.
- **Flask**: Web framework used for handling HTTP requests and responses.
- **MySQL**: Database management system for storing order information.
- **HTML/CSS/JavaScript**: Front-end technologies for building the web interface.

## Usage

1. Clone the repository to your local machine.
2. open home.html.
3. if it doesnt work then from google download ngrok before clicking download create an account in ngrok.
4. A zip folder is downloade in your downloads exttract that file into the repository where you have downloaded all my files
5. then open main.py file in the terminal run pyhton main.py
6. open cmd for the corrresponding directory where you have extracted ngrok
7. then enter ngrok http [port] the port number on which your flask application is running
8. It will give you a hhtps url
9. Paste that url in this https://dialogflow.cloud.google.com/#/agent/medico-chatbot-avqc/fulfillment and click save and restart the home.html page

## Navigation

- **Home**: Navigate to the home page of the website.
- **Menu**: View the menu of available medical supplies.
- **Location**: Find information about the location of the medical supply store.
- **About Us**: Learn more about the company behind the chatbot.
- **Contact Us**: Contact the company for inquiries or support.

## File Structure

- **main.py**: Contains the main code to handle all intents of the chatbot.
- **generic_helper.py**: Contains general functions such as `extract_session_id` and `get_str_from_food_dict`.
- **db_helper.py**: Provides functions for data retrieval and insertion into the database.
- **pharmacare.sql**: SQL file containing code to create the necessary database, tables, and stored procedures.
- **home.html**: HTML file for the front-end of the website, including navigation and chatbot interface.
- **banner.jpg**: Image file for the website banner.
- **menu.jpg**: Image file for the website menu.

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature/your-feature`).
6. Create a new Pull Request.

## Contact

For any inquiries or support, please contact us at mahendramedapati.r469@gmail.com

