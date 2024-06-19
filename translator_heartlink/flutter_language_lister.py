if __name__ == '__main__':
    ids = []
    with open("res/intl_en.arb", encoding="utf8") as file:
        for line in file:
            # print(line)
            splitter = line.split('"')
            if len(splitter) > 1 and splitter[1] != '1.0':
                print(splitter[1])
                ids.append(splitter[1])
        file.close()

    print('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
    with open("res/intl_en.arb", encoding="utf8") as file:
        for line in file:
            # print(line)
            splitter = line.split('": "')
            # if len(splitter) > 1:
            #     print(splitter[1])
            if len(splitter) > 1:
                print(splitter[1][:-3])
        file.close()
