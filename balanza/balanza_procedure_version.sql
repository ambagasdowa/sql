U S E   [ i n t e g r a a p p ]  
 G O  
 / * * * * * *   O b j e c t :     U s e r D e f i n e d F u n c t i o n   [ d b o ] . [ g e t B a l a n z a C o m p r o b a c i o n ]         S c r i p t   D a t e :   0 4 / 0 3 / 2 0 1 6   0 1 : 3 6 : 1 7   p . m .   * * * * * * /  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
   A u t h o r                   :   J e s u s   B a i z a b a l  
   e m a i l 	 	 	         :   a m b a g a s d o w a @ g m a i l . c o m  
   C r e a t e   d a t e         :   A p r i l   2 0 ,   2 0 1 5  
   D e s c r i p t i o n         :   f e t c h   t h e   B a l a n z a   f o r   a c c o u n t s   a n d   s u b   a c c o u n t s   f o r m   G L T r a n  
   @ l i c e n s e               :   M I T   L i c e n s e   ( h t t p : / / w w w . o p e n s o u r c e . o r g / l i c e n s e s / m i t - l i c e n s e . p h p )  
   D a t a b a s e   o w n e r   :   b o n a m p a k   s . a   d e   c . v  
   @ s t a t u s                 :   S t a b l e  
   @ v e r s i o n 	 	         :   1 . 0 . 9  
   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
 A L T E R   P R O C E D U R E   [ d b o ] . [ s p _ u d s p _ g e t B a l a n z a C o m p r o b a c i o n ]  
   (  
 	 @ b e g i n D a t e   n v a r c h a r ( 6 ) ,  
 	 @ e n d D a t e   n v a r c h a r ( 6 ) ,  
 	 @ C o m p a n y   v a r c h a r ( 8 0 0 0 ) ,   - -   j u s t   i n   c a s e  
 	 @ D e l i m i t e r   v a r c h a r ( 1 0 )  
   )  
  
 a s  
  
 	 d e c l a r e   @ b u s s i n e s s _ u n i t   t a b l e  
 	 (  
 	 	 C o m p a n y 	 	 n v a r c h a r ( 6 )   c o l l a t e   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S  
 	 )  
 	 i n s e r t   i n t o   @ b u s s i n e s s _ u n i t  
 	 	 s e l e c t   i t e m   f r o m   i n t e g r a a p p . d b o . f n S p l i t ( @ C o m p a n y ,   @ D e l i m i t e r )  
  
 	 S E L E C T  
 	 	 h . A c c t   A S   ' C u e n t a ' ,  
 	 	 h . S u b   A S   ' E N T I D A D E S ' ,  
 	 	 - - h . B a l a n c e T y p e   A S   A c c t H i s t _ B a l a n c e T y p e ,  
 	 	 S U B S T R I N G ( h . s u b   ,   8 ,   2 )   a s   ' e m p r e s a ' ,  
 - - 	 	 S U B S T R I N G ( h . s u b   ,   1 0 ,   6 )   a s   C e n t r o C o s t o ,  
 	 	 a . D e s c r   a s   ' D e s c r i p c i � n ' ,  
 - - 	 	 h . C p n y I D   A S   E m p r e s a D e s c ,  
 	 	 C A S E   S U B S T R I N G ( @ b e g i n D a t e ,   5 ,   2 )  
 	 	 	 W H E N   ' 0 1 '  
 	 	 	 	 T H E N   h . B e g B a l  
 	 	 	 W H E N   ' 0 2 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 0  
 	 	 	 W H E N   ' 0 3 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 1  
 	 	 	 W H E N   ' 0 4 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 2  
 	 	 	 W H E N   ' 0 5 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 3  
 	 	 	 W H E N   ' 0 6 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 4  
 	 	 	 W H E N   ' 0 7 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 5  
 	 	 	 W H E N   ' 0 8 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 6  
 	 	 	 W H E N   ' 0 9 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 7  
 	 	 	 W H E N   ' 1 0 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 8  
 	 	 	 W H E N   ' 1 1 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 9  
 	 	 	 W H E N   ' 1 2 '  
 	 	 	 	 T H E N   h . Y T D B a l 1 0  
 	 	 	 W H E N   ' 1 3 '  
 	 	 	 	 T H E N   h . Y T D B a l 1 1  
 	 	 	 E L S E   0  
 	 	 	 E N D   A S   ' I n i c i a l ' ,  
 - -  
 	 	 (  
 	 	 	 s e l e c t  
 	                       - - c a s t (   S U M ( i n t e g r a a p p . d b o . G L T r a n . D r A m t )   a s   f l o a t )  
 	 	 	       S U M ( i n t e g r a a p p . d b o . G L T r a n . D r A m t )  
 	 	 	 	 - - S U M ( C u r y D r A m t )   -   S U M ( C u r y C r A m t )   a s   R e s u l t  
 	 	 	 f r o m   i n t e g r a a p p . d b o . G L T r a n  
 	 	 	 w h e r e   i n t e g r a a p p . d b o . G L T r a n . A c c t   =   h . A c c t   - - ' 0 1 0 1 0 4 0 1 0 0 '  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . P e r P o s t   =   @ b e g i n D a t e  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . C p n y I D   =   h . C p n y I D   - -   s u m   a g a i n t s   C o m p a n i e s   i s   n o t   w o r k i n g   b e c a u s e   t h e   w h e r e   c l a u s e   s p l i t   t h e   r e s u l t s   p e r   c o m p a n y  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . P o s t e d   =   ' P '   - -   C o n t a n t  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . S u b   =   h . S u b   - -   ' 0 0 0 '  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . F i s c Y r   =   S U B S T R I N G ( @ b e g i n D a t e , 1 , 4 )  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . L e d g e r I D   =   ' R E A L '   - -   C o n s t a n t  
 	 	 	 	 	 a n d   S U B S T R I N G ( i n t e g r a a p p . d b o . G L T r a n . S u b   ,   8 ,   2 )   =   S U B S T R I N G ( h . S u b , 8 , 2 )  
 	 	 	 	 	 a n d   S U B S T R I N G ( i n t e g r a a p p . d b o . G L T r a n . S u b   ,   1 0 ,   6 )   =   S U B S T R I N G ( h . S u b , 1 0 , 6 )  
 	 	 )   a s   ' C a r g o ' ,  
 	 	 (  
 	 	 	 s e l e c t  
 	 	 	 	 - - c a s t   ( S U M ( i n t e g r a a p p . d b o . G L T r a n . C r A m t )   a s   f l o a t )  
 	 	 	 	 S U M ( i n t e g r a a p p . d b o . G L T r a n . C r A m t )  
 	 	 	 	 - - S U M ( C u r y D r A m t )   -   S U M ( C u r y C r A m t )   a s   R e s u l t  
 	 	 	 f r o m   i n t e g r a a p p . d b o . G L T r a n  
 	 	 	 w h e r e   i n t e g r a a p p . d b o . G L T r a n . A c c t   =   h . A c c t   - - ' 0 1 0 1 0 4 0 1 0 0 '  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . P e r P o s t   =   @ b e g i n D a t e  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . C p n y I D   =   h . C p n y I D   - -   s u m   a g a i n t s   C o m p a n i e s   i s   n o t   w o r k i n g   b e c a u s e   t h e   w h e r e   c l a u s e   s p l i t   t h e   r e s u l t s   p e r   c o m p a n y  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . P o s t e d   =   ' P '   - -   C o n t a n t  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . S u b   =   h . S u b   - -   ' 0 0 0 '  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . F i s c Y r   =   S U B S T R I N G ( @ b e g i n D a t e , 1 , 4 )  
 	 	 	 	 	 a n d   i n t e g r a a p p . d b o . G L T r a n . L e d g e r I D   =   ' R E A L '   - -   C o n s t a n t  
 	 	 	 	 	 a n d   S U B S T R I N G ( i n t e g r a a p p . d b o . G L T r a n . S u b   ,   8 ,   2 )   =   S U B S T R I N G ( h . S u b , 8 , 2 )  
 	 	 	 	 	 a n d   S U B S T R I N G ( i n t e g r a a p p . d b o . G L T r a n . S u b   ,   1 0 ,   6 )   =   S U B S T R I N G ( h . S u b , 1 0 , 6 )  
 	 	 )   a s   ' C r � d i t o ' ,  
 - -  
 	 	 C A S E   S U B S T R I N G ( @ e n d D a t e ,   5 ,   2 )  
 	 	 	 W H E N   ' 0 1 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 0  
 	 	 	 W H E N   ' 0 2 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 1  
 	 	 	 W H E N   ' 0 3 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 2  
 	 	 	 W H E N   ' 0 4 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 3  
 	 	 	 W H E N   ' 0 5 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 4  
 	 	 	 W H E N   ' 0 6 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 5  
 	 	 	 W H E N   ' 0 7 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 6  
 	 	 	 W H E N   ' 0 8 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 7  
 	 	 	 W H E N   ' 0 9 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 8  
 	 	 	 W H E N   ' 1 0 '  
 	 	 	 	 T H E N   h . Y T D B a l 0 9  
 	 	 	 W H E N   ' 1 1 '  
 	 	 	 	 T H E N   h . Y T D B a l 1 0  
 	 	 	 W H E N   ' 1 2 '  
 	 	 	 	 T H E N   h . Y T D B a l 1 1  
 	 	 	 W H E N   ' 1 3 '  
 	 	 	 	 T H E N   h . Y T D B a l 1 2  
 	 	 	 E L S E   0  
 	 	 E N D   A S   ' F i n a l '  
 	 F R O M   i n t e g r a a p p . d b o . A c c t H i s t   a s   h  
 	 	 I N N E R   J O I N   d b o . A c c o u n t   A S   a  
 	 	 	 O N   h . A c c t   =   a . A c c t  
 	 w h e r e  
 	 	 - - h . C p n y I D   i n   ( S E L E C T   i t e m   f r o m   d b o . f n S p l i t ( @ C o m p a n y ,   @ D e l i m i t e r ) )  
 	 	 h . C p n y I D   i n   ( s e l e c t   C o m p a n y   f r o m   @ b u s s i n e s s _ u n i t )  
 	 	 a n d   h . F i s c Y r   =   S U B S T R I N G ( @ b e g i n D a t e ,   1 ,   4 )  
 	 	 a n d   h . L e d g e r I D   =   ' R E A L '  
 	 	 a n d   h . A c c t   < >   ' 0 3 0 4 0 0 0 0 0 0 '  
 	 o r d e r   b y   h . A c c t , S U B S T R I N G ( h . s u b   ,   8 ,   2 )  
 