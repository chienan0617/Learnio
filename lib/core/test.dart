import 'package:learnio/base.dart';

@test
enum System { out }

void e() {}

// String sou =
//     "7000單字Level 4&c\\n\\apple\\type of food\\蘋果/餅購\\apple/synonyms\\apple/antonyms\\apple/extensions\\an + apple\\I am eating an apple/Apple everyday, doctor keeps away.\\我在吃蘋果%每天一蘋果，醫生遠離我/窩家假餅購%金糾every day, 森聲妓買未\$c\\n\\banana\\type of food too\\香蕉/金糾\\bananas/synonyms\\bananas/antonyms\\bananas/extensions\\a + banana\\I am eating an banana/Banana everyday, doctor keeps away.\\我在吃香蕉%每天一香蕉，醫生遠離我/窩家假金鳩%金糾every day, 森聲妓買未&2023-10-26 10:30:00.000";

// var result = TextbookDecoder.decodeTextbookFromDecodedString(sou);

String exJson = '''
{
  "name": "textbook-test",
  "units": [
    {
      "num": 1,
      "voc": [

{
  "info": {
    "langType": [
      "english",
      "chinese"
    ],
    "type": [
      "noun"
    ],
    "word": "vaccine",
    "explanation": "A substance used to stimulate the production of antibodies and provide immunity against one or several diseases, prepared from the causative agent of a disease, its products, or a synthetic substitute, treated to act as an antigen without inducing the disease.",
    "meanings": [
      "A substance used to stimulate the production of antibodies and provide immunity against one or several diseases.",
      "疫苗(n)"
    ],
    "pronounce": "/ˈvæksiːn/",
    "grammar": {
      "tenses": {
        "baseForm": null,
        "simPre": null,
        "prePar": null,
        "pasTen": null,
        "pasPar": null
      },
      "family": {
        "noun": "vaccine",
        "verb": "vaccinate",
        "adj": "vaccinated",
        "adv": null
      },
      "degree": {
        "com": null,
        "sup": null
      }
    }
  },
  "usage": {
    "synonyms": [
      "inoculant",
      "immunogen",
      "shot"
    ],
    "antonyms": null,
    "extensions": [
      "immunization",
      "antibody",
      "virus",
      "bacteria",
      "epidemic",
      "pandemic",
      "antigen"
    ],
    "collocation": [
      "COVID-19 vaccine",
      "flu vaccine",
      "get a vaccine",
      "administer a vaccine",
      "vaccine development"
    ],
    "examples": [
      "The new vaccine has proven highly effective against the virus.",
      "Children receive several vaccines as part of their routine immunization schedule."
    ],
    "exaTran": [
      [
        "The new vaccine has proven highly effective against the virus.",
        "這種新疫苗已被證明對該病毒非常有效。"
      ],
      [
        "Children receive several vaccines as part of their routine immunization schedule.",
        "兒童會依據例行免疫計畫接種多種疫苗。"
      ]
    ],
    "colTran": [
      [
        "COVID-19 vaccine",
        "新冠疫苗"
      ],
      [
        "flu vaccine",
        "流感疫苗"
      ],
      [
        "get a vaccine",
        "接種疫苗"
      ],
      [
        "administer a vaccine",
        "施打疫苗"
      ],
      [
        "vaccine development",
        "疫苗開發"
      ]
    ],
    "colExa": [
      "Millions have received the COVID-19 vaccine.",
      "I need to get a flu vaccine this year.",
      "The nurse will administer the vaccine carefully."
    ],
    "colExaTra": [
      [
        "Millions have received the COVID-19 vaccine.",
        "數百萬人已經接種了新冠疫苗。"
      ],
      [
        "I need to get a flu vaccine this year.",
        "我今年需要接種流感疫苗。"
      ],
      [
        "The nurse will administer the vaccine carefully.",
        "護士將會小心地施打這劑疫苗。"
      ]
    ]
  },
  "generatedBy": "GPT-5 Thinking mini"
}

      ]
    }
  ]
}
''';

String testVocString = '''
{
  "info": {
    "langType": "english",
    "type": ["noun", "verb"],
    "word": "decide",
    "explanation": "reach make or come to a decision about something",
    "meanings": [
      null, "決定(v);決斷(v);確定(n)"
    ],
    "pronounce": "dɪˋsaɪd",
    "grammar": {
      "tenses": {
        "baseForm": "decide",
        "simPre": "decides",
        "prePar": "deciding",
        "pasTen": "decided",
        "pasPar": "decided"
      },
      "family": {
        "none": "decision",
        "verb": null,
        "adj": "decisive",
        "adv": "decisively"
      },
      "degree": {
        "com": null,
        "sup": null
      }
    }
  },
  "usage": {
    "synonyms": ["choose", "elect", "select", "pick", "opt"],
    "antonyms": ["hesitate", "falter", "dither", "fluctuate", "vacillate"],
    "extensions": ["conclusion", "resolution", "determination", "choice", "indecision"],
    "collocation": ["decide to + V", "decide on + N", "decide between A and B"],
    "examples": ["We must decide the fates of the people who headed the coup", "I decide to eat an apple"],
    "exaTran": [[null, "我們必須決定領導政變的人的命運"], [null , "我決定要吃一顆蘋果"]],
		"colExa": ["I decide to learning English", "I decide on this beautiful shirt"]
		"colExaTra": [[null, "我決定要學習英文"], [null, "我決定要這件T"]]
  },
  "generatedBy": "GPT-5 mini"
}''';

// Textbook textbook = TextbookJson.parse(json.decode(exJson));
