Class dc.rcc.Winner Extends %Persistent [ Final ]
{

Property Short As %String;

Property Reg As %String [ SqlFieldName = Region ];

Property Rid As %Integer [ SqlFieldName = RegID ];

Index Id On (Reg, Rid) [ IdKey ];

ClassMethod NextRid(reg = "")
{
  if ..%ExistsId(reg_"||1")
  set nxt=$o(@$REPLACE($zr,1,""""""),-1)
  quit $i(nxt)
}

Storage Default
{
<Data name="WinnerDefaultData">
<Value name="1">
<Value>Short</Value>
</Value>
</Data>
<DataLocation>^dc.rcc.WinnerD</DataLocation>
<DefaultData>WinnerDefaultData</DefaultData>
<IdLocation>^dc.rcc.WinnerD</IdLocation>
<IndexLocation>^dc.rcc.WinnerI</IndexLocation>
<StreamLocation>^dc.rcc.WinnerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

