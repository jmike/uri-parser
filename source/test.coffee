Parser = require("jison").Parser
			
grammar = {
	lex: {# defines expected token classes (ze grammar)
		rules: [
			["\\?", "return 'QUERY';"]
			["filter=", "return 'FILTER';"]
			["order=|sort=", "return 'ORDER';"]
			["offset=", "return 'OFFSET';"]
			["limit=", "return 'LIMIT';"]
			["[a-zA-Z0-9%_\\-\\.]+", "return 'STRING';"]
			["[0-9]+", "return 'INTEGER';"]
			["\\:", "return '='"]
			[">\\:", "return '>='"]
			[">", "return '>'"]
			["<\\:", "return '<='"]
			["<", "return '<'"]
			["\\+", "return 'AND';"]
			["\\|", "return 'OR';"]
			[",", "return ',';"]
			["$", "return 'EOF';"]
		]
	}
	operators: [# sets associations and precedence
		["left", "AND", "OR"]
	]
	bnf: {# sets expressions
		process: [
			["QUERY expressions EOF", "return ['QUERY', $2];"]
		]
		expressions: [
			["FILTER filterExpression", "$$ = ['FILTER', $2];"]
		]
		filterExpression: [
			["filterClause", "$$ = $1;"]
			["filterExpression AND filterExpression", "console.log($$); $$ = ['AND', $$, $3];"]
			["filterExpression OR filterExpression", "$$ = ['OR', $$, $3];"]
		]
		filterClause: [
			["STRING = STRING", "$$ = ['EQUAL', $1, $3]"],
		]
	}
}

parser = new Parser(grammar)

uri = "?filter=name:mitsos|age:10+id:1"
console.log uri
results =  parser.parse(uri)
console.log JSON.stringify(results, null, 4)