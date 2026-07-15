import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vendor_story.dart';
import '../models/service_type.dart';

class VendorStoriesNotifier extends Notifier<List<VendorStory>> {
  @override
  List<VendorStory> build() => _getMockStories();

  static List<VendorStory> _getMockStories() {
    return [
      VendorStory(
        vendorId: 'papaye',
        vendorName: 'Papaye',
        vendorImage: 'assets/images/home/story_papaye.jpg',
        posts: [
          VendorStoryPost(
            id: 'papaye_1',
            mediaUrl: 'assets/images/home/promo_fufu.jpg',
            mediaType: MediaType.image,
            productName: 'The Signature Spicy Jollof',
            price: 45.00,
            caption: 'Authentic Nigeriaian jollof rice served with spicy grilled chicken and shito.',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          VendorStoryPost(
            id: 'papaye_2',
            mediaUrl: 'assets/images/home/street_abaawa.jpg',
            mediaType: MediaType.video, // Changed to video
            productName: 'Waakye Special',
            price: 35.00,
            caption: 'Fresh waakye with all the trimmings - gari, wele, egg, and pepper sauce',
            createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          VendorStoryPost(
            id: 'papaye_3',
            mediaUrl: 'assets/images/home/street_areamama.jpg',
            mediaType: MediaType.image,
            productName: 'Grilled Tilapia',
            price: 65.00,
            caption: 'Fresh tilapia grilled to perfection with banku and pepper',
            createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          ),
        ],
      ),
      VendorStory(
        vendorId: 'kfc',
        vendorName: 'KFC',
        vendorImage: 'assets/images/home/story_kfc.jpg',
        posts: [
          VendorStoryPost(
            id: 'kfc_1',
            mediaUrl: 'assets/images/home/restaurant_nana.jpg',
            mediaType: MediaType.video, // Changed to video
            productName: 'Zinger Burger Combo',
            price: 55.00,
            caption: 'Crispy zinger chicken with fries and a drink - satisfaction guaranteed!',
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          VendorStoryPost(
            id: 'kfc_2',
            mediaUrl: 'assets/images/home/restaurant_bigimage.jpg',
            mediaType: MediaType.image,
            productName: 'Hot Wings Bucket',
            price: 45.00,
            caption: 'Spicy hot wings - 8 pieces of crispy perfection',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      VendorStory(
        vendorId: 'burgerking',
        vendorName: 'Burger King',
        vendorImage: 'assets/images/home/story_burgerking.jpg',
        posts: [
          VendorStoryPost(
            id: 'bk_1',
            mediaUrl: 'assets/images/home/restaurant_bigimage.jpg',
            mediaType: MediaType.image,
            productName: 'Whopper Deluxe',
            price: 60.00,
            caption: 'Flame-grilled beef patty with fresh lettuce, tomatoes, and our signature sauce',
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
          VendorStoryPost(
            id: 'bk_2',
            mediaUrl: 'assets/images/home/street_areamama.jpg',
            mediaType: MediaType.video,
            productName: 'Chicken Royale',
            price: 50.00,
            caption: 'Premium chicken breast with mayo and lettuce in a sesame seed bun',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          VendorStoryPost(
            id: 'bk_3',
            mediaUrl: 'assets/images/home/promo_fufu.jpg',
            mediaType: MediaType.image,
            productName: 'Double Whopper',
            price: 80.00,
            caption: 'Two flame-grilled beef patties for the ultimate burger experience',
            createdAt: DateTime.now().subtract(const Duration(hours: 7)),
          ),
        ],
      ),
      VendorStory(
        vendorId: 'breakfo',
        vendorName: 'Breakfo',
        vendorImage: 'assets/images/home/story_breakfo.jpg',
        posts: [
          VendorStoryPost(
            id: 'breakfo_1',
            mediaUrl: 'assets/images/home/story_breakfo.jpg',
            mediaType: MediaType.image,
            caption: 'Fresh pastries baked daily! Come try our croissants and coffee.',
            createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          ),
        ],
      ),
      VendorStory(
        vendorId: 'pizzahut',
        vendorName: 'Pizza Hut',
        vendorImage: 'assets/images/home/story_pizzahut.jpg',
        posts: [
          VendorStoryPost(
            id: 'pizza_1',
            mediaUrl: 'assets/images/home/story_pizzahut.jpg',
            mediaType: MediaType.image,
            productName: 'Pepperoni Supreme',
            price: 65.00,
            caption: 'Loaded with pepperoni and mozzarella cheese - a classic favorite!',
            createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          ),
        ],
      ),
    ];
  }

  List<VendorStory> getStoriesForService(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.groceries:
        return [
          VendorStory(
            vendorId: 'greenhut',
            vendorName: 'GreenHut',
            vendorImage: 'assets/images/figma_groceries/greenhut_logo.png',
            posts: [
              VendorStoryPost(
                id: 'green_1',
                mediaUrl: 'assets/images/home/restaurant_nana.jpg',
                mediaType: MediaType.image,
                productName: 'Fresh Vegetables Bundle',
                price: 25.00,
                caption: 'Farm fresh vegetables delivered to your doorstep daily',
                createdAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'kfc',
            vendorName: 'KFC',
            vendorImage: 'assets/images/figma_groceries/kfc_logo.png',
            posts: [
              VendorStoryPost(
                id: 'kfc_1',
                mediaUrl: 'assets/images/home/restaurant_bigimage.jpg',
                mediaType: MediaType.image,
                productName: 'Zinger Burger Combo',
                price: 55.00,
                caption: 'Crispy zinger chicken with fries and a drink',
                createdAt: DateTime.now().subtract(const Duration(hours: 3)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'burgerking',
            vendorName: 'Burger King',
            vendorImage: 'assets/images/figma_groceries/burger_king_logo.png',
            posts: [
              VendorStoryPost(
                id: 'bk_1',
                mediaUrl: 'assets/images/home/restaurant_bigimage.jpg',
                mediaType: MediaType.image,
                productName: 'Whopper Deluxe',
                price: 60.00,
                caption: 'Flame-grilled beef patty with fresh ingredients',
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'breakfo',
            vendorName: 'Breakfo',
            vendorImage: 'assets/images/figma_groceries/breakfo_logo.png',
            posts: [
              VendorStoryPost(
                id: 'breakfo_1',
                mediaUrl: 'assets/images/home/story_breakfo.jpg',
                mediaType: MediaType.image,
                productName: 'Fresh Pastries',
                price: 15.00,
                caption: 'Fresh pastries baked daily! Croissants and coffee available.',
                createdAt: DateTime.now().subtract(const Duration(hours: 6)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'pizzahut',
            vendorName: 'Pizza Hut',
            vendorImage: 'assets/images/figma_groceries/pizza_hut_logo.png',
            posts: [
              VendorStoryPost(
                id: 'pizza_1',
                mediaUrl: 'assets/images/home/story_pizzahut.jpg',
                mediaType: MediaType.image,
                productName: 'Pepperoni Supreme',
                price: 65.00,
                caption: 'Loaded with pepperoni and mozzarella cheese',
                createdAt: DateTime.now().subtract(const Duration(hours: 8)),
              ),
            ],
          ),
        ];
      case ServiceType.market:
        return [
          VendorStory(
            vendorId: 'kejetia',
            vendorName: 'Kejetia',
            vendorImage: 'assets/images/home/story_papaye.jpg',
            posts: [
              VendorStoryPost(
                id: 'kejetia_1',
                mediaUrl: 'assets/images/home/restaurant_nana.jpg',
                mediaType: MediaType.image,
                productName: 'Traditional Kente Cloth',
                price: 150.00,
                caption: 'Authentic hand-woven kente cloth from Northern Nigeria',
                createdAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'adumtech',
            vendorName: 'Adum Tech',
            vendorImage: 'assets/images/home/story_kfc.jpg',
            posts: [
              VendorStoryPost(
                id: 'adum_1',
                mediaUrl: 'assets/images/home/restaurant_bigimage.jpg',
                mediaType: MediaType.image,
                productName: 'Smartphone Accessories',
                price: 30.00,
                caption: 'Latest phone cases, chargers, and screen protectors',
                createdAt: DateTime.now().subtract(const Duration(hours: 4)),
              ),
            ],
          ),
        ];
      case ServiceType.shop:
        return [
          VendorStory(
            vendorId: 'accramall',
            vendorName: 'Accra Mall',
            vendorImage: 'assets/images/home/story_papaye.jpg',
            posts: [
              VendorStoryPost(
                id: 'mall_1',
                mediaUrl: 'assets/images/home/restaurant_nana.jpg',
                mediaType: MediaType.image,
                productName: 'Designer Outfit',
                price: 200.00,
                caption: 'Latest fashion trends - dresses, shirts, and accessories',
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
          ),
        ];
      case ServiceType.pharmacy:
        return [
          VendorStory(
            vendorId: 'oncat',
            vendorName: 'Oncat',
            vendorImage: 'assets/images/figma_pharmacy/oncat_story.jpg',
            posts: [
              VendorStoryPost(
                id: 'oncat_1',
                mediaUrl: 'assets/images/figma_pharmacy/oncat_story.jpg',
                mediaType: MediaType.image,
                productName: 'Pain Relief Medication',
                price: 25.00,
                caption: 'Fast-acting pain relief for headaches and body aches',
                createdAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'pharmco',
            vendorName: 'Pharmco',
            vendorImage: 'assets/images/figma_pharmacy/pharmco_story.jpg',
            posts: [
              VendorStoryPost(
                id: 'pharmco_1',
                mediaUrl: 'assets/images/figma_pharmacy/pharmco_story.jpg',
                mediaType: MediaType.image,
                productName: 'Medical Supplies',
                price: 40.00,
                caption: 'Complete medical supplies and prescription medications',
                createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'helinsd',
            vendorName: 'HelinsD',
            vendorImage: 'assets/images/figma_pharmacy/helinsd_story.jpg',
            posts: [
              VendorStoryPost(
                id: 'helinsd_1',
                mediaUrl: 'assets/images/figma_pharmacy/helinsd_story.jpg',
                mediaType: MediaType.image,
                productName: 'Health Supplements',
                price: 30.00,
                caption: 'Premium health supplements and wellness products',
                createdAt: DateTime.now().subtract(const Duration(hours: 3)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'gremlon',
            vendorName: 'Gremlon',
            vendorImage: 'assets/images/figma_pharmacy/gremlon_story.jpg',
            posts: [
              VendorStoryPost(
                id: 'gremlon_1',
                mediaUrl: 'assets/images/figma_pharmacy/gremlon_story.jpg',
                mediaType: MediaType.image,
                productName: 'Pharmacy Services',
                price: 35.00,
                caption: 'Professional pharmacy services and consultations',
                createdAt: DateTime.now().subtract(const Duration(hours: 4)),
              ),
            ],
          ),
          VendorStory(
            vendorId: 'healtho',
            vendorName: 'Healtho',
            vendorImage: 'assets/images/figma_pharmacy/healtho_story.jpg',
            posts: [
              VendorStoryPost(
                id: 'healtho_1',
                mediaUrl: 'assets/images/figma_pharmacy/healtho_story.jpg',
                mediaType: MediaType.image,
                productName: 'Vitamins & Wellness',
                price: 45.00,
                caption: 'Complete range of vitamins and wellness products',
                createdAt: DateTime.now().subtract(const Duration(hours: 5)),
              ),
            ],
          ),
        ];
      default:
        return state;
    }
  }

  void markStoryAsViewed(String vendorId) {
    state = state.map((story) {
      if (story.vendorId == vendorId) {
        return VendorStory(
          vendorId: story.vendorId,
          vendorName: story.vendorName,
          vendorImage: story.vendorImage,
          posts: story.posts,
          isViewed: true,
        );
      }
      return story;
    }).toList();
  }
}

final vendorStoriesProvider = NotifierProvider<VendorStoriesNotifier, List<VendorStory>>(() {
  return VendorStoriesNotifier();
});