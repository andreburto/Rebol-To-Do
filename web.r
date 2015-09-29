REBOL [
    Title: "Web Library"
    About: "A library for web pages."
    Version: 0.1
    Creator: "Andy"
]

sanitizeString: func [ str ] [
    newstr: ""
    clear newstr
    foreach os str [
        temp: os
        switch temp [
            "&" [ temp: "&amp;" ]
            "'" [ temp: "&apos;" ]
            {"} [ temp: "&quot;" ]
            append newstr temp
        ]
    ]
    get newstr
]

makeAttribs: func [ atts ] [
    full: ""
    clear full
    if (even? length? atts) and (block? atts) and (not zero? length? atts) [
        count: 0
        att: ""
        clear att
        foreach el atts [
            either zero? count [
                count: 1
                att: join " " el
            ] [
                count: 0
                append full join att [{="} either word? el [ get el ] [ el ] {"}]
            ]
        ]
    ]
    return full
]

makeTag: func [ tag attList ] [
    newtag: ""
    clear newtag
    newtag: tag
    if not zero? length? attList [ append newtag makeAttribs attList ]
    clear attList
    return newtag
]

makeOpenTag: func [ tagOpen /attributes attribs ] [
    join "<" [makeTag tagOpen either attributes [ attribs ] [ [] ] ">"]
]

makeSingleTag: func [tagOpen /attributes attribs ] [
    join "<" [makeTag tagOpen either attributes [ attribs ] [ [] ] " />"]
]

makeCloseTag: func [tagClose] [
    join "</" [tagClose ">"]
]

makeLink: func [linkText link] [
    join makeOpenTag/attributes "a" [{href} link] [linkText makeCloseTag "a"]
]

makeImage: func [ src /alt altText ] [
    alt-text: ""
    clear alt-text
    alt-text: either alt [ altText ] [ src ]
    makeSingleTag/attributes "img" [{src} src {alt} alt-text]
]

headTag: func [ titleText ] [
    title: ""
    clear title
    title: join makeOpenTag "title" [titleText makeCloseTag "title"]
    join (makeOpenTag/attributes "head" [{lang} {en}]) [title makeCloseTag "head"]
]

generalTag: func [ type tagText attribs ] [
    either not zero? length? attribs [
        join makeOpenTag/attributes type attribs [tagText (makeCloseTag type)]
    ] [
        join makeOpenTag type [tagText (makeCloseTag type)]
    ]
]

pTag: func[ pText /style pAttribs ] [
    either style [ generalTag "p" pText [{style} pAttribs] ] [ generalTag "p" pText [] ]
]

h1Tag: func[ h1Text /style h1Attribs ] [
    either style [ generalTag "h1" h1Text [{style} h1Attribs] ] [ generalTag "h1" h1Text [] ]
]

listItem: func [item] [
	switch/default to-string (type? item) [ 
		"block" [
			either (length? item) > 1 [
				join (listItem item/1) (ulTag skip item 1)
			] [
				listItem item/1
			]
		]
		"word" [ get item ]
		"string" [ item ]
	] [ to-string item ]
]

ulTag: func [ list ] [
	generalTag "ul" (liTag list) []
]

liTag: func [ list ] [
	either (length? list) > 1 [
		join (generalTag "li" (listItem list/1) []) (liTag skip list 1)
	] [
		generalTag "li" (listItem list/1) []
	]
]