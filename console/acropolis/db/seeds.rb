
# Users
# -----------------------------

system_admin = User.create(name: 'sys_admin', email: 'sys_admin@acropolis.com', password: '12345678', password_confirmation: '12345678', full_name: 'System Administrator')
me = User.create(name: 'stanley.deng', email: 'stanley.deng@acropolis.com', password: '12345678', password_confirmation: '12345678', full_name: 'Stanley Deng')

# Basic Risk Parameters
# -----------------------------

Parameter.create(name: 'in_bound_net_worth')
Parameter.create(name: 'out_bound_net_worth')
Parameter.create(name: 'margin')
Parameter.create(name: 'exposure')

# Parameters Chinese Name
# -----------------------------

Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.name.in_bound_net_worth', value: '内盘净值')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.name.out_bound_net_worth', value: '外盘净值')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.name.margin', value: '保证金')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.parameter.name.exposure', value: '敞口')

# Basic Relation Symbols of Thresholds
# -----------------------------

RelationSymbol.create(math: '<', name: 'less_than')
RelationSymbol.create(math: '<=', name: 'less_than_and_equals_to')
RelationSymbol.create(math: '=', name: 'equals_to')
RelationSymbol.create(math: '>=', name: 'greater_than_and_equals_to')
RelationSymbol.create(math: '>', name: 'greater_than')

# Relation Symbols Chinese Name
# -----------------------------

Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.name.less_than', value: '小于')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.name.less_than_and_equals_to', value: '小于等于')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.name.equals_to', value: '等于')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.name.greater_than_and_equals_to', value: '大于等于')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.relation_symbol.name.greater_than', value: '大于')