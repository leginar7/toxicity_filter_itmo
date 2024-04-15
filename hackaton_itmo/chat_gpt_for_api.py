import requests

OPENAI_API_KEY = ""

def send_to_openai(text):
    messages = [
        {"role": "system", "content": "Вы являетесь помощником."},
        {"role": "user", "content": f'Перефразируй данный текст так, чтобы он не содержал в себе токсичные высказывания и ответь мне только перефразированным текстом. Важно понимать что данное высказывание может быть вырвано из другого полного предложения, поэтому просто перефразируй и не пытайся сделать из него самостоятельное предложение: "{text}"'}
    ]
    data = {
        "model": "gpt-4-turbo",
        "messages": messages,
        "max_tokens": 300
    }
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}"
    }
    try:
        response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=data)
    except requests.exceptions.RequestException as e:
        print('Network error occurred:', e)
    
    if response:
        return response.json()['choices'][0]['message']['content']
    else:
        return None
    
toxic_text = 'Зачем ты пишешь хуйню, дегенерат?'
remade_text = send_to_openai(toxic_text)
print(remade_text)
