import requests
from bs4 import BeautifulSoup
import logging
import os
from dotenv import load_dotenv
from openai import OpenAI
from pathlib import Path
from datetime import datetime

# Setup logging
logging.basicConfig(filename='log.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.getLogger().addHandler(logging.StreamHandler())

# Load environment variables
# Assuming config.env is in the same directory as core.py
dotenv_path = os.path.join(os.path.dirname(__file__), 'config.env')
load_dotenv(dotenv_path)
CMS_KEY = os.getenv('CMS_KEY')
OPENAI_KEY = os.getenv('OPENAI_KEY')
CMS_URL = 'https://api.thoxh.de/items/einfachkeiten'
FILES_URL = 'https://api.thoxh.de/files'

# OpenAI system message template
OPENAI_BASIC_INSTRUCTION_MESSAGE = 'You are an expert at converting German news articles into {language} plain language texts so that disabled people can read these articles more easily. Plain language is a specially regulated simple language. The linguistic expression aims to be particularly easy to understand. Easy language is intended to make it easier for people who, for various reasons, have low competence in the {language} language to understand texts. Write short sentences. Use one sentence per line, this is very important. Use one sentence for one statement. Use active voice. Do not use conditional mood. A sentence should be formed with the elements subject + predicate + object. Do not use synonyms. Split compound words: Write Bundes-Tag, not Bundestag. Plain Language is not directed to children and should address the readers as adults, using the normal (formal) pronouns. In the case of compounds, hyphens or semi-high points (also referred to as midpoints in this context) make it clear which words the compounds consist of. Abstract concepts are avoided; Where necessary, they are explained using clear examples or comparisons. Figurative language is avoided. If foreign words or technical terms appear, they are explained. Abbreviations are explained by the written form the first time they occur. Words are not written in solid capital letters. Texts are clearly laid out, each sentence is on its own line. Texts are consistently left-aligned in flutter typesetting.'
OPENAI_TITLE_INSTRUCTION_MESSAGE = 'You are an expert at converting German news articles titles into {language} plain language texts so that disabled people can read these titles more easily. The title should not be longer than 15 words. Plain language is a specially regulated simple language. The linguistic expression aims to be particularly easy to understand. Easy language is intended to make it easier for people who, for various reasons, have low competence in the {language} language to understand texts. Write short sentences. Use one sentence for one statement. Use active voice. Do not use conditional mood. A sentence should be formed with the elements subject + predicate + object. Do not use synonyms. Split compound words: Write Bundes-Tag, not Bundestag. Plain Language is not directed to children and should address the readers as adults, using the normal (formal) pronouns. In the case of compounds, hyphens or semi-high points (also referred to as midpoints in this context) make it clear which words the compounds consist of. Abstract concepts are avoided; Where necessary, they are explained using clear examples or comparisons. Figurative language is avoided. If foreign words or technical terms appear, they are explained. Abbreviations are explained by the written form the first time they occur. Words are not written in solid capital letters. Texts are clearly laid out, each sentence is on its own line. Texts are consistently left-aligned in flutter typesetting.'
OPENAI_TRANSLATE_INSTRUCTION_MESSAGE = 'You reveive a text in german plain language texts so that disabled people can read these titles more easily. You need to translate the text into english language without violating the rules of Plain language. The german text followed follwing rules Plain language is a specially regulated simple language. The linguistic expression aims to be particularly easy to understand. Easy language is intended to make it easier for people who, for various reasons, have low competence in the {language} language to understand texts. Write short sentences. Use one sentence per line, this is very important. Use one sentence for one statement. Use active voice. Do not use conditional mood. A sentence should be formed with the elements subject + predicate + object. Do not use synonyms. Split compound words: Write Bundes-Tag, not Bundestag. Plain Language is not directed to children and should address the readers as adults, using the normal (formal) pronouns. In the case of compounds, hyphens or semi-high points (also referred to as midpoints in this context) make it clear which words the compounds consist of. Abstract concepts are avoided; Where necessary, they are explained using clear examples or comparisons. Figurative language is avoided. If foreign words or technical terms appear, they are explained. Abbreviations are explained by the written form the first time they occur. Words are not written in solid capital letters. Texts are clearly laid out, each sentence is on its own line. Texts are consistently left-aligned in flutter typesetting.'
OPENAI_TRANSLATE_TITLE_INSTRUCTION_MESSAGE = 'You reveive a text in german plain language texts so that disabled people can read these titles more easily. You need to translate the text into english language without violating the rules of Plain language. The german text followed follwing rules Plain language is a specially regulated simple language. The linguistic expression aims to be particularly easy to understand. Easy language is intended to make it easier for people who, for various reasons, have low competence in the {language} language to understand texts. Write short sentences. Use one sentence for one statement. Use active voice. Do not use conditional mood. A sentence should be formed with the elements subject + predicate + object. Do not use synonyms. Split compound words: Write Bundes-Tag, not Bundestag. Plain Language is not directed to children and should address the readers as adults, using the normal (formal) pronouns. In the case of compounds, hyphens or semi-high points (also referred to as midpoints in this context) make it clear which words the compounds consist of. Abstract concepts are avoided; Where necessary, they are explained using clear examples or comparisons. Figurative language is avoided. If foreign words or technical terms appear, they are explained. Abbreviations are explained by the written form the first time they occur. Words are not written in solid capital letters. Texts are clearly laid out, each sentence is on its own line. Texts are consistently left-aligned in flutter typesetting.'

# Initialize OpenAI client
client = OpenAI(api_key=OPENAI_KEY)

class NewsItem:
    def __init__(self, title, title_en, content_de, content_en, originalTitle, originalContent, speech_id_de, speech_id_en, image_url):
        self.title = title
        self.title_en = title_en
        self.content_de = content_de
        self.content_en = content_en
        self.originalTitle = originalTitle
        self.originalContent = originalContent
        self.speech_id_de = speech_id_de
        self.speech_id_en = speech_id_en
        self.image_url = image_url
        
def scrape_news_items():
    """Scrape news articles from a website."""
    try:
        response = requests.get("https://meetingpoint-brandenburg.de/")
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "lxml")
        news_items = []

        for post in soup.find_all("div", class_="timeline-panel"):
            if "Anzeige" in post.get_text():
                logging.info("Skipping advertisement post.")
                continue

            title_element = post.find("h4").find("a")
            text_element = post.find("div", class_="timeline-body")
            image_element = post.find("img")

            if title_element and text_element and image_element and "src" in image_element.attrs:
                title = title_element.get_text(strip=True)
                text = text_element.get_text(strip=True)
                image_url = "https://www.meetingpoint-brandenburg.de" + image_element["src"].replace("small", "big")

                if not check_if_already_uploaded(title):
                    news_items.append((title, text, image_url, title, text))

        return news_items
    except requests.RequestException as e:
        logging.error(f"Failed to scrape news items: {e}")
        raise


def format_with_openai(content, language, instruction):
    """Format text using OpenAI."""
    try:
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",
            messages=[
                {"role": "system", "content": instruction.format(language=language)},
                {"role": "user", "content": content}
            ]
        )
        return response.choices[0].message.content.strip()
    except Exception as e:
        logging.error(f"Failed to format with OpenAI: {e}")
        raise

def text_to_speech_with_openai(content, language):
    """Convert text to speech using OpenAI."""
    temp_dir = Path("./temp_audio_files") 
    temp_dir.mkdir(exist_ok=True)
    speech_file_path = temp_dir / f"speech_{language}_{datetime.now().strftime('%Y%m%d%H%M%S')}.mp3"

    try:
        response = client.audio.speech.create(
            model="tts-1",
            voice="shimmer",
            input=content,
            speed=1.0
        )
        response.stream_to_file(speech_file_path)
        return speech_file_path
    except Exception as e:
        logging.error(f"Failed to generate speech: {e}")
        raise

def upload_file_to_cms(file_path):
    """Upload an audio file to the CMS."""
    try:
        with open(file_path, 'rb') as file:
            files = {'file': (file_path.name, file, 'audio/mpeg')}
            headers = {'Authorization': CMS_KEY}
            response = requests.post(FILES_URL, headers=headers, files=files)
            response.raise_for_status()  
            return response.json().get('data', {}).get('id')
    except requests.RequestException as e:
        logging.error(f"Failed to upload file to CMS: {e}")
        raise


def post_item_to_cms(news_item):
    """Post a news item to the CMS and save the title upon success."""
    data = {
        'titleGerman': news_item.title,
        'titleEnglish': news_item.title_en,
        'contentGerman': news_item.content_de,
        'contentEnglish': news_item.content_en,
        'originalTitle': news_item.originalTitle,
        'originalContent': news_item.originalContent,
        'speechSourceGerman': news_item.speech_id_de,
        'speechSourceEnglish': news_item.speech_id_en,
        'imageSource': news_item.image_url,
        'publishedAt': datetime.now().isoformat()
    }
    headers = {'Authorization': CMS_KEY}
    try:
        response = requests.post(CMS_URL, headers=headers, json=data)
        response.raise_for_status() 
        logging.info("News item posted successfully to CMS.")

        save_uploaded_title(news_item.originalTitle)
    except requests.RequestException as e:
        logging.error(f"Failed to post news item to CMS: {e}")
        raise


def check_if_already_uploaded(title):
    """Check if a title has already been uploaded."""
    try:
        with open('uploaded_items.txt', 'r', encoding='utf-8') as file:
            uploaded_titles = file.read().splitlines()
        return title in uploaded_titles
    except FileNotFoundError:
        return False

def save_uploaded_title(title):
    """Save the uploaded title to a file."""
    with open('uploaded_items.txt', 'a', encoding='utf-8') as file:
        file.write(f"{title}\n")

def main():
    """Main function to orchestrate the workflow."""
    try:
        news_items = scrape_news_items()
        for title, text, image_url, originalTitle, originalContent in news_items:
            title_de = format_with_openai(title, "German", OPENAI_TITLE_INSTRUCTION_MESSAGE)
            title_en = format_with_openai(title_de, "English", OPENAI_TRANSLATE_TITLE_INSTRUCTION_MESSAGE)
            
            content_de = format_with_openai(text, "German", OPENAI_BASIC_INSTRUCTION_MESSAGE)
            content_en = format_with_openai(content_de, "English", OPENAI_TRANSLATE_INSTRUCTION_MESSAGE)
            
            speech_file_de_path = text_to_speech_with_openai(title_de + "\n" + content_de, "German")
            speech_file_en_path = text_to_speech_with_openai(title_en + "\n" + content_en, "English")

            speech_id_de = upload_file_to_cms(speech_file_de_path)
            speech_id_en = upload_file_to_cms(speech_file_en_path)

            news_item = NewsItem(title_de, title_en, content_de, content_en, originalTitle, originalContent, speech_id_de, speech_id_en, image_url)
            post_item_to_cms(news_item)
    except Exception as e:
        logging.error(f"An error occurred in the main function: {e}")

if __name__ == "__main__":
    main()
