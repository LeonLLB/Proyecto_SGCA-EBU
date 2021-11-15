import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {

  final void Function(DateTime?) onChange;
  final String defaultText;
  final DateTime maxDate;
  final DateTime defaultDate;  
  final String lastDate;
  final bool? enabled;

  DateTimePicker({
    required this.onChange,
    required this.defaultText,
    required this.maxDate,
    required this.defaultDate,
    required this.lastDate,
    this.enabled: true
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {


  Future<DateTime?> getDate (BuildContext context,String? date)=>showDatePicker(
    context: context,
    initialDate: (date != null && date != '') ? 
    DateTime(int.parse(date.split('/')[2]),int.parse(date.split('/')[1]),int.parse(date.split('/')[0])) :
    widget.defaultDate,
    firstDate: DateTime(2000),
    lastDate: widget.maxDate
    );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            
            onPressed: ()async{
              if (widget.enabled!) {
                final date = await getDate(context,widget.lastDate);
                if(date != null){
                  widget.onChange(date);
                  setState(() {});
                }
              }
            },
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.calendar_today),
                Text(
                  (widget.lastDate == '')?
                  widget.defaultText:
                  '${widget.lastDate}',
                  style:TextStyle(fontSize:16)),
              ],
            )
          )
        )
    ]);
  }
}