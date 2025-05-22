import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  // Cores consistentes com o tema
  final Color _backgroundColor = const Color(0xFF121212);
  final Color _textColor = Colors.white;
  final Color _primaryColor = const Color(0xFFBB86FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Definições', style: TextStyle(color: _textColor)),
        backgroundColor: _backgroundColor,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildSectionTitle('Geral'),
            _buildListTile(
              title: 'Idioma',
              subtitle: 'Português',
              onTap: () {
                // TODO: Implementar a lógica para mudar o idioma
              },
            ),
            _buildListTile(
              title: 'Tema',
              subtitle: 'Escuro',
              onTap: () {
                // TODO: Implementar a lógica para mudar o tema
              },
            ),
            _buildSectionTitle('Notificações'),
            _buildListTile(
              title: 'Notificações de Eventos',
              onTap: () {
                // TODO: Implementar a lógica para ativar/desativar notificações de eventos
              },
            ),
             _buildListTile(
              title: 'Notificações de Atualizações',
              onTap: () {
                // TODO: Implementar a lógica para ativar/desativar notificações de atualizações
              },
            ),
            _buildSectionTitle('Privacidade'),
            _buildListTile(
              title: 'Termos de Serviço',
              onTap: () {
                // TODO: Implementar a lógica para mostrar os termos de serviço
              },
            ),
            _buildListTile(
              title: 'Política de Privacidade',
              onTap: () {
                // TODO: Implementar a lógica para mostrar a política de privacidade
              },
            ),
            _buildSectionTitle('Sobre'),
            _buildListTile(
              title: 'Versão',
              subtitle: '1.0.0', //TODO: ir buscar a versão da build
              onTap: () {
                // TODO: Implementar a lógica para mostrar a versão da aplicação
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _primaryColor, // Usa a cor primária
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(color: _textColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
    );
  }
}

