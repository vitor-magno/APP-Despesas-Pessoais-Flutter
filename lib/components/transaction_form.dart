import 'package:expenses/components/adaptative_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/adaptative_textfield.dart';
import '../components/adaptative_datepicker.dart';

class TransactionForms extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForms(this.onSubmit) {
    // print("Constructor Transaction Form");
  }

  @override
  _TransactionFormsState createState() {
      // print("Constructor Transaction Form");
      return _TransactionFormsState();
  } 
}

class _TransactionFormsState extends State<TransactionForms> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _TransactionFormsState(){
    // print("Crrate State");
  }

@override
  void initState(){
    super.initState();
    // print("INIT STATE");
  }

  @override
  void didUpdateWidget(Widget oldWidget){
      super.didUpdateWidget(oldWidget);
      // print("DID UPDATE");
  }

  @override
  void dispose(){
    super.dispose();
    // print("DISPOSE");
  }

  //Submit Form é a função para mostrar o que vai receber no card de transação, que é o texto e o valor. 
  _submitForm(){

      final title = _titleController.text;
      final value = double.tryParse(_valueController.text) ?? 0.0;

      if(title.isEmpty || value <= 0 || _selectedDate == null){
        return;
      }

      widget.onSubmit(title, value, _selectedDate);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
          elevation: 5,
          child: Padding(
          padding:  EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            //Dar espaçamento do form com o teclado
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom
            ),
          child: Column(children: <Widget>[
            AdaptativeTextField(
              controller: _titleController,
              onSubmitted: (value) => _submitForm(),
              label:  'Título',
            ),
            AdaptativeTextField(
                label: 'Valor(R\S)',
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              //onSubmitted serve para ao clicar no "ok" do teclado faça o "envio" do formulário
                onSubmitted: (value) => _submitForm(),
            ),
              AdaptativeDatePicker(
                  selectedDate: _selectedDate,
                  onDateChange: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                AdaptativeButton(
                  label: 'Nova Transação',
                  onPressed: _submitForm
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
