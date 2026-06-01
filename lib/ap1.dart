import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({super.key});
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Formulário Exemplo',
			theme: ThemeData(primarySwatch: Colors.blue),
			home: const FormPage(),
		);
	}
}
class FormPage extends StatefulWidget {
	const FormPage({super.key});
	@override
	State<FormPage> createState() => _FormPageState();
}
class _FormPageState extends State<FormPage> {
	final _formKey = GlobalKey<FormState>();
	final TextEditingController _nameController = TextEditingController();
	final TextEditingController _ageController = TextEditingController();
	bool _inativo = false;
	String? _savedName;
	num? _savedAge;
	bool? _savedInativo;
	@override
	void dispose() {
		_nameController.dispose();
		_ageController.dispose();
		super.dispose();
	}
	String? _validateName(String? value) {
		final name = value?.trim() ?? '';
		if (name.isEmpty) return 'Nome não pode ser vazio';
		if (name.length < 3) return 'Nome deve ter pelo menos 3 letras';
		final first = name[0];
		if (!RegExp(r'[A-Za-zÀ-ÿ]').hasMatch(first)) return 'Nome deve começar com uma letra';
		if (first != first.toUpperCase()) return 'Nome precisa começar com letra maiúscula';
		return null;
	}
	String? _validateAge(String? value) {
		final s = value?.trim() ?? '';
		if (s.isEmpty) return 'Idade é obrigatória';
		final num? parsed = num.tryParse(s);
		if (parsed == null) return 'Idade precisa ser um número válido';
		if (parsed < 18) return 'Idade precisa ser maior ou igual a 18';
		return null;
	}
	void _onSave() {
		final valid = _formKey.currentState?.validate() ?? false;
		if (!valid) return;

		setState(() {
			_savedName = _nameController.text.trim();
			_savedAge = num.tryParse(_ageController.text.trim());
			_savedInativo = _inativo;
		});
	}
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Formulário')),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Form(
							key: _formKey,
							child: Column(
								children: [
									TextFormField(
										controller: _nameController,
										decoration: const InputDecoration(
											labelText: 'Nome',
										),
										validator: _validateName,
									),
									const SizedBox(height: 12),
									TextFormField(
										controller: _ageController,
										decoration: const InputDecoration(
											labelText: 'Idade',
										),
										keyboardType: TextInputType.number,
										validator: _validateAge,
									),
									const SizedBox(height: 12),
									Row(
										mainAxisAlignment: MainAxisAlignment.start,
										children: [
											const Text('Indicador de inativo'),
											const SizedBox(width: 12),
											Switch(
												value: _inativo,
												onChanged: (v) => setState(() => _inativo = v),
											),
										],
									),
									const SizedBox(height: 16),
									ElevatedButton(
										onPressed: _onSave,
										child: const Text('Salvar'),
									),
								],
							),
						),
						const SizedBox(height: 24),
						if (_savedName == null)
							const Text('Nenhum dado salvo ainda.')
						else
							Container(
								padding: const EdgeInsets.all(16),
								decoration: BoxDecoration(
									color: (_savedInativo ?? false) ? Colors.grey : Colors.green,
									borderRadius: BorderRadius.circular(8),
								),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Nome: ${_savedName!}',
                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
										const SizedBox(height: 8),
										Text('Idade: ${_savedAge ?? ''}', 
                    style: const TextStyle(fontSize: 16)),
										const SizedBox(height: 8),
										Text('Inativo: ${(_savedInativo ?? false) ? 'Sim' : 'Não'}', 
                    style: const TextStyle(fontSize: 16)),
									],
								),
							),
					],
				),
			),
		);
	}
}
