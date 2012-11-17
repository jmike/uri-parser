Parser = require("jison").Parser
			
grammar = {
	lex: {# defines tokens and classes
		rules: [
			["\\?", "return '?';"]
			["\\&", "return '&';"]
			["filter=", "return 'FILTER';"]
			["order=|sort=", "return 'ORDER';"]
			["offset=", "return 'OFFSET';"]
			["limit=", "return 'LIMIT';"]
			["asc|desc", "return 'ORDER_TYPE';"]
			["[a-zA-Z0-9%_\\-\\.]+", "return 'STRING';"]
			["[0-9]+", "return 'INTEGER';"]
			["\\:", "return '=';"]
			["!\\:", "return '!=';"]
			[">\\:", "return '>=';"]
			["<\\:", "return '<=';"]
			[">", "return '>';"]
			["<", "return '<';"]
			["\\(", "return '(';"]
			["\\)", "return ')';"]
			["\\+", "return 'AND';"]
			["\\|", "return 'OR';"]
			[",", "return ',';"]
			["$", "return 'EOF';"]
		]
	}
	operators: [# sets associations and precedence
		["left", "AND"]
		["left", "OR"]
	]
	bnf: {# sets expressions
		process: [
			["? query EOF", "$2.unshift('QUERY'); return  $2;"]
		]
		query: [
			["expression", "$$ = [$1];"]
			["expression & query", "$$ = [].concat([$1], $3);"]
		]
		expression: [
			["FILTER filterExpression", "$$ = ['FILTER', $2];"]
			["ORDER orderExpression", "$$ = ['ORDER', $2];"]
		]
		filterExpression: [
			["filterClause", "$$ = $1;"]
			["( filterExpression )", "$$ = $2;"]
			["filterExpression AND filterExpression", "$$ = ['AND', $1, $3];"]
			["filterExpression OR filterExpression", "$$ = ['OR', $1, $3];"]
		]
		filterClause: [
			["STRING = STRING", "$$ = ['EQUAL', $1, $3]"]
			["STRING != STRING", "$$ = ['NOT_EQUAL', $1, $3]"]
			["STRING >= STRING", "$$ = ['GREATER_THAN_OR_EQUAL', $1, $3]"]
			["STRING <= STRING", "$$ = ['LESS_THAN_OR_EQUAL', $1, $3]"]
			["STRING > STRING", "$$ = ['GREATER_THAN', $1, $3]"]
			["STRING < STRING", "$$ = ['LESS_THAN', $1, $3]"]
		]
		orderExpression: [
			["orderClause", "$$ = $1;"]
		]
		orderClause: [
			["STRING = ORDER_TYPE", "$$ = [$3, $1]"]
		]
	}
}

parser = new Parser(grammar)

uri = "?filter=name!:mitsos&order=id:asc&order=id:asc"
console.log uri
tree =  parser.parse(uri)
console.log JSON.stringify(tree, null, 4)