import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/app_fonts.dart';

class NFTListPage extends StatefulWidget {
  final String address;
  final String chain;
  const NFTListPage({super.key, required this.address, required this.chain});

  @override
  _NFTListPageState createState() => _NFTListPageState();
}

class _NFTListPageState extends State<NFTListPage> {
  List<dynamic> _nftList = [];
  final String apiUrl =
      "https://sepolia.infura.io/v3/4e177e0572044cbcbe4b264b3bf38b7b";

  @override
  void initState() {
    super.initState();
    _loadNFTList();
  }

  Future<void> _loadNFTList() async {
    try {
      final body = jsonEncode({
        "jsonrpc": "2.0",
        "method": "alchemy_getNfts",
        "params": [
          {
            "owner": widget.address, // Wallet address to query
            "contractAddresses":
                [] // Add specific contract addresses if filtering NFTs..
          }
        ],
        "id": 1,
      });

      // Make the POST request to Infura
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Extract NFT data from the response
        final nfts = jsonData['result']['ownedNfts'] ?? [];
        setState(() {
          _nftList = nfts;
        });
      } else {
        throw Exception('Failed to load NFT list: ${response.body}');
      }
    } catch (e) {
      print('Error loading NFTs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _nftList.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                '😢 You have no NFTs yet',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppFonts.fontFamilyPlusJakartaSans),
              ),
            ),
          )
        : ListView.builder(
            itemCount: _nftList.length,
            itemBuilder: (context, index) {
              final nft = _nftList[index];
              final metadata = nft['metadata'] ?? {};

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nft['title'] ?? 'Unknown NFT',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      metadata['image'] != null
                          ? Image.network(
                              metadata['image'],
                              fit: BoxFit.contain,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Image not available');
                              },
                            )
                          : const Text('No image available'),
                      const SizedBox(height: 8.0),
                      Text(
                        metadata['description'] ?? 'No description available',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
