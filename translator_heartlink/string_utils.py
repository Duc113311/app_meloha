def capitalize_after_dot(input_string):
    words = input_string.split('. ')
    capitalized_words = [word if idx == 0 else word.capitalize() for idx, word in enumerate(words)]
    result = '. '.join(capitalized_words)
    return result