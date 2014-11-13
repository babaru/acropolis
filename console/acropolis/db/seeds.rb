
# Users
# -----------------------------

system_admin = User.create(name: 'sys_admin', email: 'sys_admin@acropolis.com', password: '12345678', password_confirmation: '12345678', full_name: 'System Administrator')
me = User.create(name: 'stanley.deng', email: 'stanley.deng@acropolis.com', password: '12345678', password_confirmation: '12345678', full_name: 'Stanley Deng')

# Exchanges
# -----------------------------

sse = Exchange.create(
  name:           'SSE',
  full_cn_name:   '上海证券交易所',
  short_cn_name:  '上交所',
  full_en_name:   'Shanghai Stock Exchange',
  short_en_name:  'SSE',
  type:           'StockExchange')

szse = Exchange.create(
  name:           'SZSE',
  full_cn_name:   '深圳证券交易所',
  short_cn_name:  '深交所',
  full_en_name:   'Shenzhen Stock Exchange',
  short_en_name:  'SZSE',
  type:           'StockExchange')

cffex = Exchange.create(
  name:           'CFFEX',
  full_cn_name:   '中国金融期货交易所',
  short_cn_name:  '中金所',
  full_en_name:   'China Financial Futures Exchange',
  short_en_name:  'CFFEX',
  type:           'FuturesExchange')

shfe = Exchange.create(
  name:           'SHFE',
  full_cn_name:   '上海期货交易所',
  short_cn_name:  '上期所',
  full_en_name:   'Shanghai Futures Exchange',
  short_en_name:  'SHFE',
  type:           'FuturesExchange')

dce = Exchange.create(
  name:           'DCE',
  full_cn_name:   '大连商品交易所',
  short_cn_name:  '大商所',
  full_en_name:   'Dalian Commodity Exchange',
  short_en_name:  'DCE',
  type:           'FuturesExchange')

zce = Exchange.create(
  name:           'ZCE',
  full_cn_name:   '郑州商品交易所',
  short_cn_name:  '郑商所',
  full_en_name:   'Zhengzhou Commodity Exchange',
  short_en_name:  'ZCE',
  type:           'FuturesExchange')

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

# Basic Operation of Risk Plan
# -----------------------------

Operation.create(name: 'warning', level: 1)
Operation.create(name: 'cease_open', level: 5)
Operation.create(name: 'force_close', level: 10)

# Operation Chinese Name
# -----------------------------

Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.name.warning', value: '预警')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.name.cease_open', value: '停止开仓')
Translation.create(locale: 'zh-CN', key: 'activerecord.attributes.operation.name.force_close', value: '强制平仓')

