import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeftBottomSheet extends StatefulWidget {
  const WeftBottomSheet({Key? key}) : super(key: key);

  @override
  State<WeftBottomSheet> createState() => _WeftItemBottomSheetState();
}

class _WeftItemBottomSheetState extends State<WeftBottomSheet> {



  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.90,
      width: MediaQuery.of(context).size.width * 0.50,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weft Balance', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12),

Wrap(
  children: [
    Container(
      width: 277,
      height: 93,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFEAEAEA)),
        ),
      ),padding: EdgeInsets.only(left: 10,bottom: 25),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                child: Text("Weaver Name:"),
              ),
              const SizedBox(
                width: 40,
              ),
              Text("Loom:"),
              const SizedBox(
                width: 50,
              ),
              Text("No:"),
            ],
          ),


        ],
      ),





    ),
    const SizedBox(
      width: 10,
    ),
    Container(
      width: 420,
      height: 93,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFE3E3E3)),
        ),

      ),padding: EdgeInsets.only(left: 10,bottom: 25),
      child: Row(
        children: [
          Container(
            child: Text("Warp Status:"),
          ),
          const SizedBox(
            width: 50,
          ),
          Text("Product:"),
          const SizedBox(
            width: 90,
          ),
          Text("Wages(Rs):"),
        ],
      ),


    ),



  ],
),

            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: [

                Container(
                  width: 299,
                  height: 93,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFFE3E3E3)),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10,bottom: 25),
                  child: Row(
                    children: [
                      Container(
                        child: Text("Delivery:"),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text("Received:"),
                      const SizedBox(
                        width: 60,
                      ),
                      Text("Balance:"),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: [
                const Row(
                  children: [
                    Text("Recuired Yarn",style: TextStyle(color: Color(0xFF5653D7),fontSize:15,fontWeight: FontWeight.w500),),
                    SizedBox(
                      width: 345,
                    ),
                    Text("Delivered Yarn",style: TextStyle(color: Color(0xFF5653D7),fontSize:15,fontWeight: FontWeight.w500),),

                  ],
                ),
                SizedBox( height: 30,),Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 325,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                        ),
                      ),
                        child: Column(
                          children: [
                            Container(
                              width: 325,
                              height: 30,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF7F1FF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                                ),
                              ),padding: EdgeInsets.only(left: 5),
                              child: const Row(
                                children: [
                                  Text('S.No'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Date'),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text('Yarn Name'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('Quantity'),

                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                      width: 325,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                        ),
                      ),
                        child: Column(
                          children: [
                            Container(
                              width: 325,
                              height: 30,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF7F1FF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                                ),
                              ),padding: EdgeInsets.only(left: 5),
                              child: const Row(
                                children: [
                                  Text('S.No'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Date'),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text('Yarn Name'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('Quantity'),

                                ],
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                )

              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              children: [
                const Row(
                  children: [
                    Text("Delivery Yarn Balance",style: TextStyle(color: Color(0xFF5653D7),fontSize:15,fontWeight: FontWeight.w500),),
                    SizedBox(
                      width: 290,
                    ),
                    Text("Used Yarn",style: TextStyle(color: Color(0xFF5653D7),fontSize:15,fontWeight: FontWeight.w500),),

                  ],
                ),
                SizedBox( height: 30,),Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 325,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                        ),
                      ),
                        child: Column(
                          children: [
                            Container(
                              width: 325,
                              height: 30,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF7F1FF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                                ),
                              ),padding: EdgeInsets.only(left: 5),
                              child: const Row(
                                children: [
                                  Text('S.No'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Date'),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text('Yarn Name'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('Quantity'),

                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                      width: 325,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                        ),
                      ),
                        child: Column(
                          children: [
                            Container(
                              width: 325,
                              height: 30,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF7F1FF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                                ),
                              ),padding: EdgeInsets.only(left: 5),
                              child: const Row(
                                children: [
                                  Text('S.No'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Date'),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text('Yarn Name'),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text('Quantity'),

                                ],
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                )

              ],
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              children: [
                const Row(
                  children: [
                    Text("Weaver Yarn Stock",style: TextStyle(color: Color(0xFF5653D7),fontSize:15,fontWeight: FontWeight.w500),),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                      width: 325,
                      height: 150,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 325,
                            height: 30,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFF7F1FF),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.20, color: Color(0xFF626262)),
                              ),
                            ),padding: EdgeInsets.only(left: 5),
                            child: const Row(
                              children: [
                                Text('S.No'),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Date'),
                                SizedBox(
                                  width: 30,
                                ),
                                Text('Yarn Name'),
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Quantity'),

                              ],
                            ),
                          ),
                        ],
                      )


                    ),
                  ],
                )
              ],
            )

      ],
    ),
      ),
    );
  }
}