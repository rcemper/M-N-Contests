Class dc.rcc.Prize Extends %SerialObject
{

Property Value As %Integer;

Property Winner As dc.rcc.Winner;

Storage Default
{
<Data name="PrizeState">
<Value name="1">
<Value>Value</Value>
</Value>
<Value name="2">
<Value>Winner</Value>
</Value>
</Data>
<State>PrizeState</State>
<StreamLocation>^dc.rcc.PrizeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
