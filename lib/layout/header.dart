import 'package:flutter/material.dart';
import '../styles/consts.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Header({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : 32.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: bgPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Başlık, Arama ve Profil
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol kısım - Başlık
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontFamily: fontNunitoSans,
                  ),
                ),
              ),
              // Orta kısım - Arama
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: isSmallScreen ? 200 : 300,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: secondaryTextColor, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: fontNunitoSans,
                              color: primaryTextColor,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                                fontFamily: fontNunitoSans,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Sağ kısım - Profil
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 16 : 20,
                      backgroundImage:
                          AssetImage('assets/images/profile_picture.jpg'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isSmallScreen) ...[
            SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontFamily: fontNunitoSans,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required List<String> items,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontFamily: fontNunitoSans,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.blue,
            size: 20,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72.0);
}
