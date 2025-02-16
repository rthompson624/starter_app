import React, { createContext, useContext, useState, useEffect } from 'react';

interface User {
  id: number;
  email: string;
  // Add other user properties as needed
}

interface AuthContextType {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
  signUp: (email: string, password: string) => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  // Helper function to get the stored token
  const getToken = () => localStorage.getItem('auth_token');

  // Helper function to set the token
  const setToken = (token: string) => localStorage.setItem('auth_token', token);

  // Helper function to remove the token
  const removeToken = () => localStorage.removeItem('auth_token');

  // Helper function to get auth headers
  const getAuthHeaders = () => {
    const token = getToken();
    return {
      'Content-Type': 'application/json',
      ...(token ? { 'Authorization': `Bearer ${token}` } : {})
    };
  };

  useEffect(() => {
    const validateToken = async () => {
      const token = getToken();
      if (token) {
        try {
          const response = await fetch('/api/v1/validate_token', {
            headers: getAuthHeaders()
          });
          if (response.ok) {
            const data = await response.json();
            setUser(data.user);
          } else {
            removeToken();
            setUser(null);
          }
        } catch (error) {
          console.error('Token validation failed:', error);
          removeToken();
          setUser(null);
        }
      }
      setLoading(false);
    };

    validateToken();
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      const response = await fetch('/api/v1/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ user: { email, password } }),
      });
      
      if (!response.ok) throw new Error('Sign in failed');
      
      const data = await response.json();
      setToken(data.token);
      setUser(data.data);
    } catch (error) {
      console.error('Sign in error:', error);
      throw error;
    }
  };

  const signOut = async () => {
    try {
      const response = await fetch('/api/v1/logout', { 
        method: 'DELETE',
        headers: getAuthHeaders()
      });

      if (!response.ok) {
        throw new Error('Sign out failed');
      }

      removeToken();
      setUser(null);
    } catch (error) {
      console.error('Sign out error:', error);
      // Even if the server request fails, we should clear the local state
      removeToken();
      setUser(null);
      throw error;
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      const response = await fetch('/api/v1/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ user: { email, password } }),
      });
      
      if (!response.ok) throw new Error('Sign up failed');
      
      const data = await response.json();
      setToken(data.token);
      setUser(data.data);
    } catch (error) {
      console.error('Sign up error:', error);
      throw error;
    }
  };

  return (
    <AuthContext.Provider value={{ user, loading, signIn, signOut, signUp }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}; 