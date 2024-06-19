import codecs
import os
import csv
import re
from shutil import rmtree
from string_utils import capitalize_after_dot

OUTPUT_FILE_NAME = "strings_new"

INPUT_FILE_NAME = "Heartlink - Translator V2 - translate"
FILE_TYPE = "tsv"
line_header = None
line_content = []
PASS_COLUMN = ['Text Key', 'Capitalize', 'Default', 'Translate Value']
language_type_array = PASS_COLUMN.copy()

with open("res/" + INPUT_FILE_NAME + "." + FILE_TYPE, encoding="utf8") as file:
    tsv_file = csv.reader(file, delimiter="\t")

    # printing data line by line
    for line in tsv_file:
        if line_header is None:
            line_header = line
        else:
            line_content.append(line)

for lang in line_header:
    res = re.findall(r'\(.*?\)', lang)
    if len(res) < 1:
        continue
    res = res[0]
    res = res.replace('(', '').replace(')', '')
    language_type_array.append(res)

print(language_type_array)

directoryParent = '../lib/l10n'

if os.path.exists(directoryParent):
    rmtree(directoryParent)

if not os.path.exists(directoryParent):
    os.makedirs(directoryParent)

for idx, lang in enumerate(language_type_array):
    if lang in PASS_COLUMN:
        continue
    directory = directoryParent
    if not os.path.exists(directory):
        os.makedirs(directory)

    with codecs.open(directory + '/' + 'intl_' + lang + '.arb', 'w', 'utf-8') as outfile:
        outfile.write('{\n')
        outfile.write('\t"@@locale": "' + lang + '"')
        for i in range(len(line_content)):
            content = line_content[i]
            if idx >= len(content) or content[idx] == '#VALUE!' or content[idx] == '' or content[0] == '':
                continue

            outfile.write(',\n')
            str_formatted = content[idx].replace('\"', '\\\"')
            str_formatted = str_formatted.replace('98689', '%1$d').replace('9868 9868', '%1$d').replace('9868', '') \
                .replace('98671', '%1$s').replace('98 676771', '%1$s').replace('78 67671', '%1$s') \
                .replace('XOPMT', '%s').replace('xopmt', '%s').replace('Xopmt', '%s') \
                .replace('\\\\\"', '\\\"') \
                .replace('\\ \\\"', '\\\"') \
                .replace('”', '\"') \
                .replace('\\ \\„', '\\\"') \
                .replace('\\,', '\\\",') \
                .replace('„', '\"')

            str_formatted = str_formatted.replace('\\“', '\\\"')
            str_formatted = str_formatted.replace('“', '\\\"')
            str_formatted = str_formatted.replace('\\\"', '\"')
            str_formatted = str_formatted.replace('\"', '\\\"')
            str_formatted = str_formatted.replace('\\ \\\"', '\\\"') \

            if 'capitalize' in content[1].lower() and lang != 'en':
                str_formatted = str_formatted.capitalize()
            if 'uppercase' in content[1].lower() and lang != 'en':
                str_formatted = str_formatted.upper()
            if 'underline' in content[1].lower():
                str_formatted = '<u>' + str_formatted + '</u>'

            str_formatted = capitalize_after_dot(str_formatted)
            
            # if "\'" in content[idx]:
            #     print(content[idx])
            #     print(str_formatted)
            outfile.write('\t"' + content[0] + '": "' + str_formatted + '"')
        outfile.write('\n}')

        outfile.close()


# print('當您點擊“繼續"時，heartlink將發送帶有驗證代碼的文本。消息和數據速率可能適用。經過驗證的電話號碼可用於登錄。'.replace('“', '\\\"'))