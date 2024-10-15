import 'package:flutter/material.dart';
import 'package:nomad_app/shared/shared.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Screen'),
      ),
      body: const  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Wallet Screen',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        }, 
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add)
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}