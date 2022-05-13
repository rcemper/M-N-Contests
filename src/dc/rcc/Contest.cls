Class dc.rcc.Contest Extends %Persistent [ Final ]
{

Property Title As %String(MAXLEN = "");

Property Start As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 2, SqlFieldName = Start_Date ];

Property End As %Date [ InitialExpression = {1+$h}, SqlFieldName = End_Date ];

Property C As array Of dc.rcc.Prize;

Property X As array Of dc.rcc.Prize;

Storage Default
{
<Data name="C">
<Attribute>C</Attribute>
<Structure>subnode</Structure>
<Subscript>"C"</Subscript>
</Data>
<Data name="ContestDefaultData">
<Value name="1">
<Value>Title</Value>
</Value>
<Value name="2">
<Value>Start</Value>
</Value>
<Value name="3">
<Value>End</Value>
</Value>
</Data>
<Data name="X">
<Attribute>X</Attribute>
<Structure>subnode</Structure>
<Subscript>"X"</Subscript>
</Data>
<DataLocation>^dc.rcc.ContestD</DataLocation>
<DefaultData>ContestDefaultData</DefaultData>
<IdLocation>^dc.rcc.ContestD</IdLocation>
<IndexLocation>^dc.rcc.ContestI</IndexLocation>
<StreamLocation>^dc.rcc.ContestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
