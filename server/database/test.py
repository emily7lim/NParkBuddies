# Description: Test the OpenAI API with the OpenAI Python client.

from openai import OpenAI
from dotenv import dotenv_values

import os
current_directory = os.getcwd()
server_directory = os.path.abspath(os.path.join(current_directory, os.pardir))

# Load environment variables from .env file
config = dotenv_values(os.path.join(server_directory, ".env"))
print("API Key from .env file:", config.get("OPENAI_API_KEY"))

api_key = config.get("OPENAI_API_KEY")
if api_key:
    # Define the client if API key is found
    client = OpenAI(api_key=api_key)
    model_name = "gpt-4"
    # Now you can use 'client' to interact with OpenAI API
    chat_completion = client.chat.completions.create(
        model=model_name,
        messages=[
            {"role": "system",
             "content": "Generate short reviews for park facilities for a booking app for the National Parks Board. You may use Singlish terms and grammar structures and avoid long paragraphs. You may use other languages. Usage of emojis is disallowed.. Avoid long paragraphs."},
            {"role": "user",
             "content": "Generate a review for this. The park is " + "East Coast Park" + " and the facility is " + "BBQ pit" +
                        ". The rating is " + str(4) + "."}
        ])
    content = chat_completion.choices[0].message.content
    print(content)
else:
    print("ERROR: API key not found in .env file.")
