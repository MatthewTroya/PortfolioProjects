"Module to translate phrases"

from ibm_watson import LanguageTranslatorV3
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator

URL_LT= "https://api.us-south.language-translator.watson.cloud.ibm.com/instances" \
    "/87078826-d38b-405b-9cb2-d6bfffdb690e"
APIKEY_LT= "OYBUZkYcC2jlcAhVyoLzz_PqZnFVpnWk6_23STMbWc6r"
VERSION_LT='2018-05-01'
AUTHENTICATOR = IAMAuthenticator(APIKEY_LT)
LANGUAGE_TRANSLATOR = LanguageTranslatorV3(version=VERSION_LT,authenticator=AUTHENTICATOR)
LANGUAGE_TRANSLATOR.set_service_url(URL_LT)

def english_to_french(text):
    """
    Function that returns a translated phrase from english to french
    """
    if not isinstance(text, str):
        raise TypeError('Please insert a valid text')
    translated_object = LANGUAGE_TRANSLATOR.translate(text, model_id='en-fr').get_result()
    translated_text = translated_object['translations'][0]['translation']
    return translated_text

def english_to_german(text):
    """
    Function that returns a translated phrase from english to german
    """
    if not isinstance(text, str):
        raise TypeError('Please insert a valid text')
    translated_object = LANGUAGE_TRANSLATOR.translate(text, model_id='en-de').get_result()
    translated_text = translated_object['translations'][0]['translation']
    return translated_text
