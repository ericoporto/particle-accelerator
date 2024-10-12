// new module header

managed struct ParticleDefinition {
    int offsetX; // Offset from the emitter position
    int offsetY; // Offset from the emitter position
    int life;    // Lifetime of the particle
    int vx;      // mili Velocity in x direction
    int vy;      // mili Velocity in y direction
    int gravity; // mili Gravity effect on the particle
    int initialTransparency; // Initial transparency
    int finalTransparency; // Final transparency
    int initialWidth; // Initial width
    int finalWidth; // Final width
    int initialHeight; // Initial height
    int finalHeight; // Final height
};

managed struct Particle {
    float x;
    float y;
    int life;
    int initialLife;
    int overlayIndex; // This refers to the overlay in the overlay pool
    float vx; // x velocity
    float vy; // y velocity
    float gravity; // this is vertical acceleration downwards
    int transparency;
    int width;
    int height;
    int initialTransparency; 
    int finalTransparency; 
    int initialWidth; 
    int finalWidth; 
    int initialHeight; 
    int finalHeight;

    // Initialize the particle with its position, life, velocity, and transparency
    import void Init(ParticleDefinition* def, int x, int y, int overlayIndex);
    import void Update(); // Update particle position and overlay
    import bool IsAlive(); // Check if particle is still alive
};

struct Emitter {
  protected int x;
  protected int y;
  protected int particleLife;
  protected int emitParticleCount;
  protected int particleCount;
  protected int sprite; // The sprite slot to use for particles
  protected int gravity;
  protected Particle* particles[]; // Pool of particles
  protected ParticleDefinition* definitions[]; // Array of particle definitions
  protected int definitionsCount; // Count of particle definitions
  
  /// Set sprite
  import void SetSprite(int graphic);  
  /// Set emitter possible particle definitions
  import void SetParticleDefinitions(ParticleDefinition* definitions[], int definitionsCount);
  /// Update emitter position
  import void SetPosition(int x, int y);

  /// Initialize the emitter
  import void Init(int x, int y, ParticleDefinition* definitions[], int definitionsCount, int emitParticleCount = 10, int particleCount = 50, int sprite = 0, int gravity = 0);
  /// Emit a single particle
  import void EmitSingleParticle();  
  /// Emit particles
  import void Emit(); 
  /// Update all particles
  import void Update();
};

/// Global Particle Emitter
import Emitter GPE;